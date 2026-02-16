 cat run.sh
#!/bin/bash

# --- Inputs ---
MODEL_ID=$1
PROMPT_FILE=$2

# Check for inputs
if [ "$#" -ne 2 ]; then
    echo "Usage: ./run_test.sh <model-id> <prompt-file>"
    exit 1
fi

echo "--- 1. Clearing RAM ---"
lms unload --all > /dev/null 2>&1

echo "--- 2. Loading Model (Reduced Context for Stability) ---"
# Lowered from 8192 to 2048 to prevent the kernel panic/swap thrashing you saw earlier
lms load "$MODEL_ID" --context-length 5120

echo "--- 3. Running Inference ---"
# cat feeds the prompt; lms chat handles the execution
cat "$PROMPT_FILE" | lms chat

echo -e "\n--- 4. Cleanup ---"
lms unload --all > /dev/null 2>&1
echo "--- Test Finished ---"

