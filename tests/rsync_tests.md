
## Setup

```
mkdir -p destination
mkdir -p data/output_dir/
touch data/output_dir/out_file{1,2}
WORKING_DIR=$(pwd)/destination
LOCAL_DIR=$(pwd)
```

### Copying a directory

```
OUTPUT=data/output_dir
RELATIVE_PATH=$(dirname "$OUTPUT")
mkdir -p $WORKING_DIR/$RELATIVE_PATH
rsync -a $OUTPUT $WORKING_DIR/$RELATIVE_PATH
```

This works

```
OUTPUT=data/output_dir/out_file
RELATIVE_PATH=$(dirname "$OUTPUT")
mkdir -p $WORKING_DIR/$RELATIVE_PATH
rsync -a $OUTPUT* $WORKING_DIR/$RELATIVE_PATH
```
