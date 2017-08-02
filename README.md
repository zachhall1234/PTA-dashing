# P800 Payments dashboard.

Forked from NISP and modified for the Marriage Allowance scrum team and then again for the P800 payments microservice.
NISP board can be found at https://github.tools.tax.service.gov.uk/DDCN/nisp-dashboard.
Marriage Allowance board can be found at https://github.tools.tax.service.gov.uk/DDCN/tamc-dashboard.

## Setup
To run the dashboard, copy the `config.yml.example` file to `config.yml` and enter your JIRA log in credentials and GA Profile ID.

JIRA credentials used should be for your team's service account, if this is not set up or you do not have the credentials talk to your scrum master.

To use the GA Widget you will need a JSON keyfile with Service Account credntials. More information can be found at: https://confluence.tools.tax.service.gov.uk/display/DP/Creating+GA+APIs

Then start the dashboard by running the command:
`dashing start`

# Troubleshooting dashing!

## undefined method '[]=' for false:FalseClass

**Symptoms**
Upon starting dashing with `dashing start`, it starts logging the above exception about an undefined method on falseclass.
When trying to visit the page, the entire dashboard app crashes with an error related to:

```
undefined method 'inject' for false:FalseClass
```

**Fix**

Check `history.yml`. If it looks something like this:

```
---false
...
```

Delete it.

# Notes on the use of Google Analytics

Under metrics, queries are in the format "ga:queryName", the "queryName" part of the query determines which metric is pulled through. A list of these can be found at https://ga-dev-tools.appspot.com/query-explorer/, in the pale grey text in the "metrics" drop down box.
