
## Profiling a corpus

We can get a summary profile of the corpus in a couple of different ways.  At the cost of reparsing the corpus, we can simply use the `profile` function

```@example corpus
profile1 = profile(tc, parser)
```

Alternatively, we can reuse our existing Vector of `AnalyticalToken`s like this.
```@example corpus
counts = count_analyses(parsed)
label = "Profile for " * string(tc)
profile2 = profile(counts, label)
```


The profile object has a ton of useful information.



```@example corpus
 vocabulary_density(profile1)
```



```@example corpus
 token_coverage(profile1)
```

See the API documentation for a full list of the functions you can apply to a profile.