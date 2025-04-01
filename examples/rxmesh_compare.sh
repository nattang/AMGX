# make amgx_rxmesh executable
cd ../build
make amgx_rxmesh -j16

#output directory containing A.mtx, B.mtx, C.mtx
OUTPUT_DIR="../../RXMesh-AMGX/output/"

#if not specified or found, input
if [ ! -d "$OUTPUT_DIR" ]; then
    echo "Output DIR not found at $OUTPUT_DIR"
    exit 1
fi

CONFIG_PATH="../src/configs/AGGREGATION_JACOBI.json"
if [ ! -f "$CONFIG_PATH" ]; then
    echo "Config not found at $CONFIG_PATH"
    exit 1
fi

for dir in "$OUTPUT_DIR"*/; do
    dir_name=$(basename "$dir")
    dir_name=$(echo "$dir_name" | xargs)


    A_MATRIX="$dir/A.mtx"
    B_MATRIX="$dir/B.mtx"
    X_MATRIX="$dir/X.mtx"

    if [ ! -f "$A_MATRIX" ] || [ ! -f "$B_MATRIX" ] || [ ! -f "$X_MATRIX" ]; then
        echo "Skipping $dir_name - Doesn't contain necessary .mtx files"
        continue
    fi

    echo "Running amgx_rxmesh for $dir_name..."
    ./examples/amgx_rxmesh -c "$CONFIG_PATH" -m "$A_MATRIX" -B "$B_MATRIX" -X "$X_MATRIX"
    echo "-------------------------------"
done