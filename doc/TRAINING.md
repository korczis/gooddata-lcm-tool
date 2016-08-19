## Prerequisites

### Mac OS Specific

Following prerequisites are required **ONLY** on Mac OS X Platform.

#### XCode

- https://developer.apple.com/xcode/

#### Command Line Tools for XCode

- http://railsapps.github.io/xcode-command-line-tools.html

#### Brew

```
# Install brew package manager
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

### Common

Following prerequisites are required regardless of platform.

#### Ruby

```
# Add GPG key for verification of downloaded stuff
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3

# Install RVM
\curl -sSL https://get.rvm.io | bash -s stable

# Install Ruby
rvm install 2.2.5

# Install bundler (ruby package/dependency manager)
rvm install bundler
```

#### Github Account

Create [github account](https://github.com/join).

# Agenda

## Segments Management

- Create segment

## Projects provisioning
- Create project from master ✓
- Synchronize LDM with master
- Synchronize ETLs with master
- Synchronize objects (dashboards,reports, metrics...)
    - partial (only non-custom)
- Migrate projects between Vertica / Postgres (not re-provisioning from master as custom objects may be in place)!
- Migrate projects between segments => Create 2nd segment (New master, e.g. Premium Product version) and migrate half of existing workspaces to the new segment (nmodified ETL, LDM, UI)
- Deleting project ✓
    - Hard delete ✓
    - Soft delete = remove users, wait for N days before actually deleting project ✓

## Users provisioning
- Create user in domain
- Add user to project
    - Automatically adding with "default" role or role from input
    - Syncing roles based on input
    - Ability to change role in UI => don't resync role from input (ignore certain user attributes when finding diff in input and actual state on platform)
    - Ability to add user manually and not having him removed when not on input
- Remove user from project

## Usage

### CLI: gooddata-lcm

```
# Clone from github
git clone git@github.com:gooddata/goodot.git

# Enter folder with sources
cd goodot

# Install dependencies using bundler
bundle install

# Build gem locally
rake build

# Install built gem
gem install pkg/gooddata-lcm-0.0.3.gem

# Verify version of installed LCM gem
lcm version
```



### appstore & bricks

## LCM

### Initialize Provisioning Data

### Create Master Project

#### Using Ruby Script

```
bundle exec scripts/create_project.rb
```

### Create Segment 

- Manually create segments
- Programatically create segments

### Initial Provisioning

- Run provisioning

### Additional Provisioning

- Update provisioning data
- Run provisioning

## References

### Prerequisites

- [brew](http://brew.sh/)
- [RVM](https://rvm.io/)

### LCM

- [appstore](https://github.com/gooddata/appstore)
- [gooddata-lcm](https://github.com/gooddata/goodot)