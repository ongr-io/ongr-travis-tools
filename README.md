ongr-travis-tools
-------

##About
The aim of this project is to restart your organization travis CI builds nightly. In case of ONGR, this is useful since symfony bundles depend on each other. This script is ran as a cronjob once per day. It firstly restarts all latest travis CI builds for all organization repos (no merges or forks). After this is done, it restarts the remaining failed or errored builds. 
##Installation

The script depends on the [TravisCI command-line tool](https://github.com/travis-ci/travis.rb). Installation instructions can be found [here](https://github.com/travis-ci/travis.rb#installation). After you've installed travis gem successfully, you need to authenticate against a github account which has access rights to your github organization in order to restart travis CI builds. There are a few methods for doing [this](https://github.com/travis-ci/travis.rb#login). Perhaps the laziest one is with `travis login --auto`. For this to work, you need to add your [GitHub token](https://help.github.com/articles/creating-an-access-token-for-command-line-use/) to your `~/.github-oauth-token` file first. 

## Usage
The script has to be added as a cronjob to repeat once every 24hours. In order for it to work, you need to add your $PATH to the crontab. The script should be added as follows:

```
* * * * * /bin/sh /<PATH>/travis-tools.sh <ORGANIZATION_NAME> >> /<PATH>/logfile 2>&1
```

Here's a working example, assuming you created a separate user to run this cron:

```
$ crontab -l -u travis-tools
<...>
# For more information see the manual pages of crontab(5) and cron(8)
#
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games
# m h  dom mon dow   command
00 23 * * * /bin/sh /home/travis-tools/travis-tools.sh ongr-io >> /home/travis-tools/travis.log 2>&1
```

## Troubleshooting
* If you are receiving an error similar to this while installing travis `ERROR:  Error installing travis:
	ERROR: Failed to build gem native extension.`, check out [this section](https://github.com/travis-ci/travis.rb#troubleshooting). 
* If you notice the cronjob is not working, try to run the script manually or check your system's cron log (e.g.`/var/log/syslog` `/var/log/cron`). 
* If the script returned errors, they should be found in the logfile you defined in your cronjob. 

##License

MIT - see the accompanying [LICENSE](https://github.com/ongr-io/ongr-travis-tools/blob/master/LICENSE) file for details.
