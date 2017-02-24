#!/usr/bin/expect
#
# Author: Adonys Maceo (adomaceo@yahoo.es)
#
# Run a command to the remote node using Telnet Client
#

log_user 0
set timeout 5
set hostName [lindex $argv 0]
set userName [lindex $argv 1]
#set password [lindex $argv 2]
#set command  [lindex $argv 3]
set telnetport 23
set telnetuser   "Username:"
set telnetpasswd "Password:"
set telnetexit   "quit"
set prompt "#"; # default prompt

#log_file telnet-nodeexecutor.log;

puts "Argumentos: $argv"

# use RD env variable from node attributes for telnet-port value, default to 23:
catch {set telnetport $env(RD_NODE_TELNET_PORT)}

# use RD env variable from node attributes for telnet-prompt
catch {set prompt $env(RD_NODE_TELNET_PROMPT)}

# use RD env variable from node attributes for telnet-check-user
catch {set telnetuser $env(RD_NODE_TELNET_CHK_USER)}

# use RD env variable from node attributes for telnet-check-password
catch {set telnetpasswd $env(RD_NODE_TELNET_CHK_PASSWD)}

# use RD env variable from node attributes for telnet-exit-cmd
catch {set telnetexit $env(RD_NODE_TELNET_EXIT_CMD)}

# use RD env variable from node attributes for password
catch {set password $env(RD_NODE_PASSWORD)}

# use RD env variable from node attributes for command to execute
catch {set command $env(RD_EXEC_COMMAND)}

#if {[llength $argv] <= 3} {
#  send_user "Usage: telnet-nodeexecutor.sh hostname \'username\' password \'command\'\n"
#  exit 1
#}

spawn telnet $hostName $telnetport

expect {
    timeout {
        send_user "Telnet connection to $host timed out.\n"
        exit 1
    }
    eof { 
        catch wait result
        puts $expect_out(buffer)
        exit [lindex $result 3] 
     }
    -re $telnetuser {
        send "$userName\r"
    }
}

expect {
    timeout {
        send_user "Telnet exit for error in username.\n"
        exit 1
    }
    eof { 
        catch wait result
        puts $expect_out(buffer)
        exit [lindex $result 3] 
     }

    -re $telnetpasswd {
        send "$password\r";
    }
}

expect { 
    timeout {
        send_user "Telnet exit for error in username or password.\n"
        exit 1
    }
    eof { 
        catch wait result
        puts $expect_out(buffer)
        exit [lindex $result 3] 
     }
    -re $prompt {
        log_user 1
        send "$command\r"
    }
}

expect {
    timeout {
        send_user "Telnet exit for error in command.\n"
        exit 1
    }
    eof { 
        catch wait result
        puts $expect_out(buffer)
        exit [lindex $result 3] 
     }
    "More--" {
            send " "
            exp_continue
        }
    -re $prompt {
        log_user 0
        send "$telnetexit\r";
    }
}
