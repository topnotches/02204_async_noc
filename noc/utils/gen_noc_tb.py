NOC_MESH_LENGTH = 4
testfile_name = "./noc/test/noc_tb.vhd"
preamble_filename = "./noc/utils/preamble.vhd"
final_steps_filename = "./noc/utils/final_steps.vhd"
def read_file_contents(file_path):
    with open(file_path, 'r') as file:
        data = file.read()
    return data

with open(testfile_name, "w") as testfile:
    tests = read_file_contents(preamble_filename)
    for in_x in range(NOC_MESH_LENGTH):
        for in_y in range(NOC_MESH_LENGTH):
            for out_x in range(NOC_MESH_LENGTH):
                for out_y in range(NOC_MESH_LENGTH):
                    if in_x == out_x and in_y == out_y:
                        continue
                    else:
                        tests = tests + (f"""
            locals.local_in({in_y}, {in_x}).data <= init_package_if({in_y}, {in_x}, {out_y}, {out_x});
            wait for 10*time_resolution;
            locals.local_in({in_y}, {in_x}).req <= not locals.local_in({in_y}, {in_x}).req;
            wait until locals.local_out({out_y},{out_x})'event;
            assert locals.local_out({out_y},{out_x}).data = locals.local_in({in_y},{in_x}).data report "package failure from " & integer'image({in_y}) & "," & integer'image({in_x}) & " to " & integer'image({out_y}) & "," & integer'image({out_x}) severity failure;

            wait for 3*time_resolution;
            locals.local_in({out_y}, {out_x}).ack <= not locals.local_in({out_y}, {out_x}).ack;
                            """)
    tests = tests + (read_file_contents(final_steps_filename))
    testfile.write(tests)
