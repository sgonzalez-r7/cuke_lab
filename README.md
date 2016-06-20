# Cuke Lab

### The Problem
Need a way to debug and fix intermittent cucumner failures, e.g., a scenario that fails 5 times out of 100.

--

### Getting Started
1. `cd pro/ui/tmp`
1. `git clone git@github.com:sgonzalez-r7/cuke_lab.git`
2. `cd cuke_lab`
3. `bundle install`
6. `rake spec`
7. Verify specs are passing.

--

### Workflow

**Repeatablity Lab Example**

1. Identify an intermittently failing test
2. `run/bin prepare NAME`
3. `bin/run repeat --name=NAME --features=FEATURE1.feature FEATURE2.feature  --cuke_opts='--tags @focus' -n=10`
4. `bin/run analysis NAME`

--

### Commands

#### `prepare` - creates a lab directory structure

`bin/run prepare NAME`

```
labs
└── NAME
    ├── data
    └── results
```

--

#### `repeat` - runs cucumber `n` times and collects the results
`bin/run repeat --name=NAME --features=FEATURE1 FEATURE2 --cuke_opts='--tags @focus' -n=10`

Note: `FEATURE1` and `FEATURE2` are specified relative to features directory, e.g., `pro/ui/features`

**pro-tip** - use the `--dry-run` option to verify the commands without running cucumber.  To see all the command line options for `repeat`: `bin/run help repeat`

Results are collected in the `data` directory.

```
labs
└── NAME
    ├── data
    │   ├── run_00001.json
    │   ├── run_00002.json
    │   |── run_00003.json
    |.. |── ...
    |.. └── run_00010.json
    └── results
```

--

#### `analysis` - calcuates the failure distribution of a repeatability experiment
The analysis command reads the cucumber output in the `data` directory and calculates the failure distribution.  The distribution is written in 2 formats: `distribution.json` and `distribution.csv`.  The `json` file is OK for human consumption. The `csv` file, however, is meant to be consumed by Excel or some other data analysis tool.

`bin/run analysis NAME`

```
labs
└── NAME
    ├── data
    │   ├── run_00001.json
    │   ├── run_00002.json
    │   |── run_00003.json
    |.. |── ...
    |.. └── run_00010.json
    └── results
        ├── distribution.json
        └── distribution.csv
```

examples

```
# distribution.json
[
  {
    "failure": {
      "feature": "/Users/sgonzalez/rapid7/pro/ui/features/sessions/session_collect.feature",
      "scenario": "Scenario: Collect Data from a Session",
      "step": "When I click on the first Active Session link",
      "error_message": "Unable to find css \"#active_sessions\" (Capybara::ElementNotFound)"
    },
    "n": 5
  },
  {
    "failure": {
      "feature": "/Users/sgonzalez/rapid7/pro/ui/features/sessions/session_collect.feature",
      "scenario": "Scenario: Collect Data from a Session",
      "step": "When I click the \"Collect System Data\" button to submit input",
      "error_message": "Unable to find button \"Collect System Data\" (Capybara::ElementNotFound)"
    },
    "n": 2
  },
]
```

```
# failure_data.csv
/Users/sgonzalez/rapid7/pro/ui/features/sessions/session_collect.feature,Scenario: Collect Data from a Session,When I click on the first Active Session link,"Unable to find css ""#active_sessions"" (Capybara::ElementNotFound)",1,5
/Users/sgonzalez/rapid7/pro/ui/features/sessions/session_collect.feature,Scenario: Collect Data from a Session,"When I click the ""Collect System Data"" button to submit input","Unable to find button ""Collect System Data"" (Capybara::ElementNotFound)",2,2
```

