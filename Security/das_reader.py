"""
Amazon RDS for Oracle DAS Lab
This scripts will process the database activity stream events and printing them on the console.

Dependencies:
none

License:
This sample code is made available under the MIT-0 license. See the LICENSE file.
"""

# Dependencies
import zlib
import boto3
import base64
import json
import time
import sys
import aws_encryption_sdk
from Crypto.Cipher import AES
from aws_encryption_sdk import CommitmentPolicy
from aws_encryption_sdk import DefaultCryptoMaterialsManager
from aws_encryption_sdk.internal.crypto import WrappingKey
from aws_encryption_sdk.key_providers.raw import RawMasterKeyProvider
from aws_encryption_sdk.identifiers import WrappingAlgorithm, EncryptionKeyType
from os import environ
import urllib3
import argparse
import datetime

# Define parser
parser = argparse.ArgumentParser()
parser.add_argument('-r', '--region_name', help="The AWS region")
parser.add_argument('-i', '--resource_id', help="The resource id of the DB cluster")
parser.add_argument('-s', '--stream_name', help="The stream name of the Kinesis stream used by DAS for the DB Instance")
parser.add_argument('-f', '--filter-service', help="Filter out events generated by the RDS managed service (monitoring and health checks)", type=int, default=1)
args = parser.parse_args()

# Instructions
print("Press Ctrl+C to quit this test...")
if args.filter_service:
    print("Filtering is enabled, only user events are displayed, service events are skipped. Disable with parameter '-f0'.")

# Init encryption client with correct committment policy
enc_client = aws_encryption_sdk.EncryptionSDKClient(commitment_policy=CommitmentPolicy.REQUIRE_ENCRYPT_ALLOW_DECRYPT)

# MasterPeyProvider class
class MyRawMasterKeyProvider(RawMasterKeyProvider):
    provider_id = "BC"

    def __new__(cls, *args, **kwargs):
        obj = super(RawMasterKeyProvider, cls).__new__(cls)
        return obj

    def __init__(self, plain_key):
        RawMasterKeyProvider.__init__(self)
        self.wrapping_key = WrappingKey(wrapping_algorithm=WrappingAlgorithm.AES_256_GCM_IV12_TAG16_NO_PADDING, wrapping_key=plain_key, wrapping_key_type=EncryptionKeyType.SYMMETRIC)

    def _get_raw_key(self, key_id):
        return self.wrapping_key

# Function to decrypt the payload
def decrypt_payload(payload, data_key):
    my_key_provider = MyRawMasterKeyProvider(data_key)
    my_key_provider.add_master_key("DataKey")
    decrypted_plaintext, header = enc_client.decrypt(
        source=payload,
        materials_manager=aws_encryption_sdk.DefaultCryptoMaterialsManager(master_key_provider=my_key_provider))
    return decrypted_plaintext

# Function to decompress payload
def decrypt_decompress(payload, key):
    decrypted = decrypt_payload(payload, key)
    # Ignore error:  Error -3 while decompressing data: invalid distance too far back
    try:
        return zlib.decompress(decrypted, zlib.MAX_WBITS + 1)
    except Exception:
        pass


# Create AWS session and clients
session = boto3.session.Session(region_name=args.region_name)
kms = session.client('kms')
kinesis = session.client('kinesis')

# Spinny thing
spinner_items = ['|', '/', '-', '\\']
spinner_idx = 0
spinner_was_active = False
spinner_last_update = 0

try:
    # Get stream information
    response = kinesis.describe_stream(StreamName=args.stream_name)
    shard_iters = []
    for shard in response['StreamDescription']['Shards']:
        # Use ShardIteratorType=TRIM_HORIZON to display all messages
        # Use ShardIteratorType=LATEST to get most current data
        # Use ShardIteratorType=AT_TIMESTAMP with timestamp 5 minutes ago to just get newer data
        shard_iter_response = kinesis.get_shard_iterator(
            StreamName=args.stream_name,
            ShardId=shard['ShardId'],
            ShardIteratorType='AT_TIMESTAMP',
            Timestamp=datetime.datetime.utcnow() - datetime.timedelta(minutes=5)
        ) 
        shard_iters.append(shard_iter_response['ShardIterator'])

    # Traverse shard iterators and get records
    while len(shard_iters) > 0:
        next_shard_iters = []
        
        # Loop through iterators
        for shard_iter in shard_iters:
            # Get Kinesis records, loop through them
            response = kinesis.get_records(ShardIterator=shard_iter, Limit=10000)
            for record in response['Records']:
                record_data = record['Data']
                record_data = json.loads(record_data)
                
                # Decode and decrypt the payload
                payload_decoded = base64.b64decode(record_data['databaseActivityEvents'])
                data_key_decoded = base64.b64decode(record_data['key'])
                data_key_decrypt_result = kms.decrypt(CiphertextBlob=data_key_decoded, EncryptionContext={'aws:rds:db-id': args.resource_id})
                plaintext = decrypt_decompress(payload_decoded, data_key_decrypt_result['Plaintext']).decode('utf8')
                
                # Decode JSON DAS record
                das_event = json.loads(plaintext)

                # Traverse the event list and see if any of the events belong to the 'rdsadmin' and 'rdssec' user
                if "databaseActivityEventList" in das_event and das_event["databaseActivityEventList"]:
                    for event in das_event["databaseActivityEventList"]:
                        # Should we exclude events generated by the service itself (monitoring, health checks)?
                        if args.filter_service:
                            # Matching event found?
                            if ("dbUserName" in event and len(event["dbUserName"]) > 0 and event["dbUserName"] not in ("RDSADMIN","RDSSEC")):
                                # Print event, use sys.stdout.write to account for progress indicator
                                sys.stdout.write(json.dumps(event))
                                sys.stdout.write("\n")
                                sys.stdout.flush()

                                # Progress indicator was not active
                                if spinner_was_active:
                                    spinner_was_active = False
                            
                            # Otherwise, just show a spinner ever 1/2 sec
                            else:
                                # Progress indicator output
                                if spinner_was_active == False or (time.time() - spinner_last_update)*1000 > 500:
                                    sys.stdout.write("%s\r"%spinner_items[spinner_idx])
                                    sys.stdout.flush()
                                    spinner_was_active = True
                                    spinner_idx += 1
                                    if spinner_idx > 3:
                                        spinner_idx = 0
                                    spinner_last_update - time.time()
                        
                        # If no exclusion, print all events
                        else:
                            print(json.dumps(event))

            # If there is an iterator in the response, add it to the list
            if 'NextShardIterator' in response:
                next_shard_iters.append(response['NextShardIterator'])
                time.sleep(0.5)

        # Process the next set of iterators
        shard_iters = next_shard_iters


# Trap keyboard interrupt, exit
except KeyboardInterrupt:
    sys.exit("\nStopped by the user")
