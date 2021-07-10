class Multirun (gdb.Command):
    """Run multiple commands in gdb"""

    def __init__(self):
        super(Multirun, self).__init__("multirun", gdb.COMMAND_USER)

    def invoke(self, arg, from_tty):
        for cmd in arg.split(";"):
            gdb.execute(cmd.lstrip())

Multirun()
