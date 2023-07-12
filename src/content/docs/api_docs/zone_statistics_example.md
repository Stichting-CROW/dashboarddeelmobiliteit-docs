---
title: Zone statistics example
description: A zone statistics example in Python
---

Because we want starting using the api as accessible as possible we will provide some example code in Python to get started. The example code is in the repository of this documentation website [Github](https://github.com/Stichting-CROW/dashboarddeelmobiliteit-docs/tree/main/src/examples/zone_stats). If you have a nice script you want to share, feel free to do a pull request to add another example.

### Install dependencies

```bash
cd docs/src/examples/zone_stats
python -m venv ENV
source ENV/bin/activate
pip install -r requirements.txt
```

### Run script

```bash
python get_rentals.py <municipality_code>
python get_rentals.py GM0599
```
