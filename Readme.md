# DevSecOps Metrics and how to extract them

Rest of this document will dive into some rows in more detail as needed.
Everything *manual* to be migrated to *automated* with the help of scripts in this project.
 
 ```

| Metric                             | Definition                                         | Method / Comments                            |
|------------------------------------+----------------------------------------------------+----------------------------------------------|
| D = Deploys in period T            | individual succesful deployments to production     | *manual* inspection of jenkins               |
| DF_T Deployment frequency          | D/T                                                |                                              |
| DF All time deployment frequency   | sum(DF_Ti)/sum(len(T))                             | notice Ts might be different length          |
| RAVG = Rolling window average DF_T | mean(DF_T) for last n measurements                 | n = "window" size                            |
| I_T = Issue Volume                 | issues closed in period                            | *manual*. Ideally equal to merges, but not   |
| I = All time Issue Volume          | sum(I_T)                                           | *manual*. Aided by script                    |
| Test coverage                      | % of source lines executed when running unit tests | coverage.py                                  |
| Lead Time                          | mean of Issue creation to completion               | *manual*. Aided by script                    |
| Process Time                       | mean Issue assignment to completion                | *manual*. Aided by script                    |
| Dynamic vulnerability coverage     | HTTP end points exercised in test/total            | *manual*.                                    |
| Static Code Quality Score          | pylint                                             |                                              |
| *Availability*                     | 1-failure rate (assume 1 replica)                  | focus on strict measurement of downtime      |
| Vulnerabilities                    | total number of vulnerabilities                    | focus on process for reduction, not ranking  |
| Mean time to recovery              | average time from detected down to up              | More important is total downtime(see avail.) |
| Burn down rate                     | delta(sum(task estimates),t1,t2)/(t2-t1)           | shown as confidence of completion            |

```

Next to be measured:
 - Deployment time (easy in AWS projects, slightly harder in current projects)

# Availability when failure dominated by node failure (hardware, network partition etc)

Given k replicas, availability is normally understood as a function of fault Tolerance to k-1 failures

 - Replication → higher availability
 - Given server failure probability f →  Availability of object: 1-f
 - for K replicas availability (1-f^k)
 
```
 |    f | availability with no replication | k=3 replicas | k =5 replicas    |
 |  0.1 |                              0.9 |         99.9 | 99.999 (5 nines) |
 | 0.05 |                              .95 |      99.9875 | 6 nines          |
 | 0.01 |                              .99 |      6 nines | 10 nines         |
```

# Availability when failure dominated by software quality

 - Given k replicas and same bug, all replicas die on same input → Replication useless.
 - Given k replicas and most downtime from simultaneous critical bug fix to all replicas → Replication useless.
 
 Focus during development on measuring accurately the downtime, not on number of replicas.

f = downtime/time
availability = 1-f

count *all* downtime (even planned).


# Useful commands for deriving metrics above

## leadtime

```
./leadtime -h
leadtime [options] -g <git server url> -p <project number> {-m milestone}
Report create and closed times for each closed issue
Options:
   -v : Verbose mode
   -h : Help
set environment variable GIT_AUTH_TOKEN before usage. See https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html
``` 

Using leadtime to extract id,created,closed,description,assignee,state,labels,milestone:

``` 
./leadtime -g https://git.devsecops.trendmicro.com -p 86
``` 

Removing items marked as "large" (internal convention):

``` 
./leadtime -g https://git.devsecops.trendmicro.com -p 86 > all_issues_soc.txt; sed -i '' '/\"large\"/d' ./all_issues_soc.txt
``` 

#All issues in json
``` 
curl -k --header "PRIVATE-TOKEN: maH6NEVERWASMYREALTOKEN6qDH1K9" https://git.devsecops.trendmicro.com/api/v4/projects/90/issues  
cat all_issues.json | jq '.[.state] | .id' | wc -l > issues
``` 

#All issues SOC project in current milestone as csv
./leadtime -g https://git.devsecops.trendmicro.com -p 86 > all_issues_soc.txt; sed -i '' '/\"large\"/d' ./all_issues_soc.txt

# If this works, why call it manual?

 - Detection of basic "gaming" strategies not implemented (unassign, close, recreate, assign)
 - Conversion between json and csv is not production-level (consider tag: "let,me,hack,you")

#
Remote Git branches and the last commit date for each branch. Sort by most recent commit date.

``` 
for branch in `git branch -r | grep -v HEAD`;do echo -e `git show --format="%ci %cr" $branch | head -n 1` \\t$branch; done | sort -r
``` 











