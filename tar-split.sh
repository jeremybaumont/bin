tar -czf /dev/stdout $(DIRECTORY_OR_FILE_TO_COMPRESS) | split -d -b
$(CHUNK_SIZE_IN_BYTES) - $(FILE_NAME_PREFIX)
