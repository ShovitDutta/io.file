from google.cloud import storage
import os

# Function that triggers from a new object on storage
def ciss_move_data_from_staging(event, context):
    """Background Cloud Function to be triggered by Cloud Storage.
       This generic function logs relevant data when a file is changed,
       and works for all Cloud Storage CRUD operations.
    Args:
        event (dict):  The dictionary with data specific to this type of event.
                       The `data` field contains a description of the event in
                       the Cloud Storage `object` format described here:
                       https://cloud.google.com/storage/docs/json_api/v1/objects#resource
        context (google.cloud.functions.Context): Metadata of triggering event.
    Returns:
        None; the output is written to Cloud Logging
    """
    try:
        print(f"Event ID: {context.event_id}")
        print(f"Event type: {context.event_type}")
        print("Bucket: {}".format(event["bucket"]))
        print("File: {}".format(event["name"]))
        print("Metageneration: {}".format(event["metageneration"]))
        print("Created: {}".format(event["timeCreated"]))
        print("Updated: {}".format(event["updated"]))

        source_bucket_name = os.environ.get('src_bucket_name')
        destination_bucket_name = os.environ.get('dest_bucket_name')

        file_name = event['name']

        storage_client = storage.Client()

        # Get the source bucket and file
        source_bucket = storage_client.bucket(source_bucket_name)
        source_blob = source_bucket.blob(file_name)

        # Get the destination bucket
        destination_bucket = storage_client.bucket(destination_bucket_name)

        # Copy the file to the destination bucket
        new_blob = source_bucket.copy_blob(source_blob, destination_bucket)

        # Delete the file from the source bucket
        source_blob.delete()

        print(f"File {file_name} moved from {source_bucket_name} to {destination_bucket_name}")
    except Exception as err:
        print(f"Unexpected {err=}, {type(err)=}")