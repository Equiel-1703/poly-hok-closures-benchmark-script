#!/bin/bash

# Define the output file name
OUTPUT_FILE="poly-hok-closure-results.log"
RUNS_PER_BENCHMARK=2 # CHANGE TO 30 LATER ----------------------------------------------------<<<

# Define directories for benchmarks
BENCHMARKS_DIR="benchmarks"
CLOSURES_DIR="closures"
CUDA_DIR="cuda"

# --- Run Benchmark Functions ---
run_benchmark() {
    local benchmark_name="$1"
    local benchmark_input="$2"

    local i # Loop variable

    for ((i=1; i<=RUNS_PER_BENCHMARK; i++)); do
        mix run $BENCHMARKS_DIR/$benchmark_name $benchmark_input >> "$OUTPUT_FILE" 2>&1
    done
}

run_CUDA_benchmark() {
    local benchmark_name="$1"
    local benchmark_input="$2"

    local output_name="${benchmark_name%.cu}.out"

    # Check if the compiled file does not exist
    if [ ! -f "$BENCHMARKS_DIR/$CUDA_DIR/$output_name" ]; then
        # Compile the CUDA benchmark if it does not exist
        nvcc -o "$BENCHMARKS_DIR/$CUDA_DIR/$output_name" "$BENCHMARKS_DIR/$CUDA_DIR/$benchmark_name"
    fi

    local i # Loop variable

    # Run the compiled CUDA benchmark
    for ((i=1; i<=RUNS_PER_BENCHMARK; i++)); do
        "./$BENCHMARKS_DIR/$CUDA_DIR/$output_name" $benchmark_input >> "$OUTPUT_FILE" 2>&1
    done
}

# ------------------ Script Start ------------------
echo "Starting Poly-Hok Closure Benchmarks..."

echo "- Poly-Hok Closure Benchmarks Results -" > "$OUTPUT_FILE"
date >> "$OUTPUT_FILE"
echo -e "Tests conducted by:\tAndre R. Du Bois & Henrique G. Rodrigues\n" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE" # Add a blank line for readability

# ------------------ Julia Benchmarks ------------------
echo "Running Julia Benchmarks..."
INPUTS="7168 9216 11264"

echo -e "Julia (no closure)\n" >> "$OUTPUT_FILE"

BENCH="julia.ex"
for INPUT in $INPUTS; do
    run_benchmark "$BENCH" "$INPUT"
done
echo "" >> "$OUTPUT_FILE"

echo -e "Julia (closure)\n" >> "$OUTPUT_FILE"

BENCH="$CLOSURES_DIR/julia.ex"
for INPUT in $INPUTS; do
    run_benchmark "$BENCH" "$INPUT"
done
echo "" >> "$OUTPUT_FILE"

echo -e "Julia (CUDA)\n" >> "$OUTPUT_FILE"

BENCH="julia.cu"
for INPUT in $INPUTS; do
    run_CUDA_benchmark "$BENCH" "$INPUT"
done
echo "" >> "$OUTPUT_FILE"

# ------------------ MM Benchmarks ------------------
echo "Running MM Benchmarks..."
INPUTS="128 256 512"
# INPUTS="11000 13000 15000" # CHANGE TO THIS LATER ----------------------------------------------------<<<

echo -e "MM (no closure)\n" >> "$OUTPUT_FILE"

BENCH="mm.ex"
for INPUT in $INPUTS; do
    run_benchmark "$BENCH" "$INPUT"
done
echo "" >> "$OUTPUT_FILE"

echo -e "MM (closure)\n" >> "$OUTPUT_FILE"

BENCH="$CLOSURES_DIR/mm.ex"
for INPUT in $INPUTS; do
    run_benchmark "$BENCH" "$INPUT"
done
echo "" >> "$OUTPUT_FILE"

echo -e "MM (CUDA)\n" >> "$OUTPUT_FILE"

BENCH="mm.cu"
for INPUT in $INPUTS; do
    run_CUDA_benchmark "$BENCH" "$INPUT"
done
echo "" >> "$OUTPUT_FILE"

# ------------------ NBody Benchmarks ------------------
echo "Running NBody Benchmarks..."
INPUTS="128 256 512"
# INPUTS="600000 800000 1000000" # CHANGE TO THIS LATER ----------------------------------------------------<<<

echo -e "NBody (no closure)\n" >> "$OUTPUT_FILE"

BENCH="nbodies.ex"
for INPUT in $INPUTS; do
    run_benchmark "$BENCH" "$INPUT"
done
echo "" >> "$OUTPUT_FILE"

echo -e "NBody (closure)\n" >> "$OUTPUT_FILE"

BENCH="$CLOSURES_DIR/nbodies.ex"
for INPUT in $INPUTS; do
    run_benchmark "$BENCH" "$INPUT"
done
echo "" >> "$OUTPUT_FILE"

echo -e "NBody (CUDA)\n" >> "$OUTPUT_FILE"

BENCH="nbodies.cu"
for INPUT in $INPUTS; do
    run_CUDA_benchmark "$BENCH" "$INPUT"
done
echo "" >> "$OUTPUT_FILE"

# ------------------ Raytracer Benchmarks ------------------
echo "Running Raytracer Benchmarks..."
INPUTS="7168 9216 11264"

echo -e "Raytracer (no closure)\n" >> "$OUTPUT_FILE"

BENCH="raytracer.ex"
for INPUT in $INPUTS; do
    run_benchmark "$BENCH" "$INPUT"
done
echo "" >> "$OUTPUT_FILE"

echo -e "Raytracer (closure)\n" >> "$OUTPUT_FILE"

BENCH="$CLOSURES_DIR/raytracer.ex"
for INPUT in $INPUTS; do
    run_benchmark "$BENCH" "$INPUT"
done
echo "" >> "$OUTPUT_FILE"

echo -e "Raytracer (CUDA)\n" >> "$OUTPUT_FILE"

BENCH="raytracer.cu"
for INPUT in $INPUTS; do
    run_CUDA_benchmark "$BENCH" "$INPUT"
done
echo "" >> "$OUTPUT_FILE"

# ------------------ Script End ------------------

echo "Script finished. All command output has been saved to '$OUTPUT_FILE'."
