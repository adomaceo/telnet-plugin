# Rundeck telnet Plugin

##Description
A Rundeck [Node Executor](http://rundeck.org/docs/plugins-user-guide/node-execution-plugins.html) plugin that allow to execute commands on remote nodes over telnet.

##Configuration

- `passwordStoragePath` - Rundeck default storage path for the telnet user password (currently it is not working)

This plugin provides a NodeExecutor called `telnet`, which you can set as on your node defintion:

	<node name="telnetdevicename" node-executor="telnet" .../>

Or set as the default NodeExecutor for your project/framework properties file, with `service.NodeExecutor.default.provider=telnet`.

These Node attributes are used to connect or iteract to the remote host:

* `username` - Remote telnet username, required..
* `hostname` - Remote telnet host required.
* `password` - Remote telnet password, required.
* `telnet_port` - Remote telnet port, default is `23`.
* `telnet_prompt` - Remote telnet prompt, default is `#`.
* `telnet_chk_user` - Output pattern for user input, default is `Username:`.
* `telnet_chk_passwd` - Output pattern for password input, default is `Password:`.
* `telnet_exit_cmd` - Telnet exit command, default is `quit`.


##Requierements
This plugin requiere of [expect](https://linux.die.net/man/1/expect)