# make amgx_rxmesh executable
cd ../build
make amgx_rxmesh -j16

#output directory containing A.mtx, B.mtx, C.mtx
OUTPUT_DIR="../../RXMesh-AMGX/output/dragon/"
A_MATRIX="$OUTPUT_DIR/A.mtx"
B_MATRIX="$OUTPUT_DIR/B.mtx"
X_MATRIX="$OUTPUT_DIR/X.mtx"

#if not specified or found, input
if [ ! -d "$OUTPUT_DIR" ]; then
    echo "Output DIR not found at  $OUTPUT_DIR not found"
    exit 1
fi

CONFIG_PATH="../src/configs/AGGREGATION_JACOBI.json"
if [ ! -f "$CONFIG_PATH" ]; then
    echo "Config not found at $CONFIG_PATH"
    exit 1
fi

echo "Running amgx_rxmesh..."
./examples/amgx_rxmesh -c "$CONFIG_PATH" -m "$A_MATRIX" -B "$B_MATRIX" -X "$X_MATRIX"
