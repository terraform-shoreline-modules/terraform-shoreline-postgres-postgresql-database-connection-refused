

#!/bin/bash



# Restart the PostgreSQL service

sudo systemctl restart postgresql



# Wait for the service to restart

sleep 5



# Verify that the service is running

sudo systemctl status postgresql