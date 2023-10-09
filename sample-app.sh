#!/bin/bash
set -euo pipefail

# Define the directories to be created
directories=("tempdir" "tempdir/templates" "tempdir/static")

# Loop through the directories
for dir in "${directories[@]}"; do
  # Check if the directory exists
  if [ -d "$dir" ]; then
    echo "Directory '$dir' already exists. Skipping..."
  else
    # Create the directory if it doesn't exist
    mkdir -p "$dir"
    echo "Created directory '$dir'"
  fi
done





cp sample_app.py tempdir/.
cp -r templates/* tempdir/templates/.
cp -r static/* tempdir/static/.

cat > tempdir/Dockerfile << _EOF_
FROM python
RUN pip install flask
COPY  ./static /home/myapp/static/
COPY  ./templates /home/myapp/templates/
COPY  sample_app.py /home/myapp/
EXPOSE 5050
CMD python /home/myapp/sample_app.py
_EOF_

cd tempdir || exit
docker build -t sampleapp .
docker run -t -d -p 5050:5050 --name samplerunning sampleapp
docker ps -a 
