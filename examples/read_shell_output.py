import subprocess
import re

def run_shell_command(command):
    result = subprocess.run(command, shell=True, text=True, capture_output=True)
    if result.returncode == 0:
        return result.stdout.strip()
    else:
        print("Error running script:\n", result.stderr)
        return None

# saves json of relevant stats
def parse_AMGX_output(output):
    # regexes for data
    obj_pattern = re.compile(r"Running amgx_rxmesh for ([\w\-]+)\.\.\.") 
    rows_pattern = re.compile(r"Matrix A is scalar and has (\d+) rows")
    setup_time_pattern = re.compile(r"setup:\s*(\d+\.\d+)\s*s")
    solve_time_pattern = re.compile(r"solve:\s*([\d\.]+(?:e[+-]?\d+)?)\s*s")

    results = {}

    obj_names = obj_pattern.findall(output)
    rows = rows_pattern.findall(output)
    setup_times = setup_time_pattern.findall(output)
    solve_times = solve_time_pattern.findall(output)

    print(obj_names, len(obj_names))
    print(len(setup_times))

    for i, obj in enumerate(obj_names):
        num_rows = int(rows[i])
        setup_time = sum(map(float, setup_times[i * 3:i * 3 + 3]))
        solve_time = sum(map(float, solve_times[i * 3:i * 3 + 3]))
        
        results[obj] = {
            "num_rows": num_rows,
            "total_setup_time": setup_time,
            "total_solve_time": solve_time
        }

    return results



def main():
    command = "./rxmesh_compare.sh" # run benchmarking solver
    output = run_shell_command(command)
    
    if output:
        print(output)
        results = parse_AMGX_output(output)
        print(results)
    else:
        print("Failed to execute command.")

if __name__ == "__main__":
    main()
