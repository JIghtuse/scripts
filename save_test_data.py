#!/usr/bin/python3

"""
Contest I/O splitter/saver, CIOS

Splits test data and saves to input and output file.

hackerrank testcase format:

*****************
Sample Input

<input data>
...
Sample Output

<output data>
...
*****************
"""


import notify2
import sys

PROGRAM = "cios"

INPUT_START = "Sample Input"
OUTPUT_START = "Sample Output"

INPUT_FILE_PATH = "/tmp/input01.txt"
OUTPUT_FILE_PATH = "/tmp/output01.txt"

MINIMAL_LINES = 6


def notify_and_terminate(msg):
    notification = notify2.Notification(PROGRAM, msg)
    notification.set_urgency(notify2.URGENCY_CRITICAL)
    notification.show()
    sys.exit(1)


def terminate_on_not_enough_data(data):
    if len(data) < MINIMAL_LINES:
        error_msg = f"Not enough data, need at least {MINIMAL_LINES} lines"
        notify_and_terminate(error_msg)


def save_file(path, data):
    "Saves @data to @path"

    with open(path, "w") as output:
        for line in data:
            print(line, file=output)


def split_and_save(data, input_filename, output_filename):
    terminate_on_not_enough_data(data)

    # Skip empty lines in the end
    while len(data[-1]) == 0:
        data.pop()

    terminate_on_not_enough_data(data)

    input_start = data.index(INPUT_START)
    output_start = data.index(OUTPUT_START)

    if output_start - input_start < 3:
        notify_and_terminate("Invalid data format")

    # Skip marker and newline
    save_file(input_filename, data[input_start + 2:output_start])
    save_file(output_filename, data[output_start + 2:])

    msg = f"""Input length: {output_start - input_start - 2}
              Output length: {len(data) - output_start - 2}"""
    notify2.Notification(f"{PROGRAM} - Data saved", msg).show()


def main():
    notify2.init(PROGRAM)

    data = sys.argv[1].split('\n')

    try:
        split_and_save(data, INPUT_FILE_PATH, OUTPUT_FILE_PATH)
    except ValueError as e:
        error_msg = "Missing input or output start marker in data"
        notify_and_terminate(error_msg)


if __name__ == "__main__":
    main()
