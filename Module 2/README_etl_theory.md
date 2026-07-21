# Module 2 

## ETL Theory
Task: Create a star schema using four different data sources (timesheet, absences, attendance report by training session, Exam & Absence Schedule)
using historical attributes for employees (grade, discipline, line manager, du). The modelling & reporting should include employee at date and monthly aggrgated report.  

## Tables
- [TimeSheet](/Module%202/ETL%20Theory/Tables/timesheet.sql)
- [Absences](/Module%202/ETL%20Theory/Tables/absences.sql)
- [Attendance Report by training session](/Module%202/ETL%20Theory/Tables/attendance_report.sql)
- [Exam & Absence Schedule](/Module%202/ETL%20Theory/Tables/exam_absence_schedule.sql)

## Dims
- [Dim Employee](/Module%202/ETL%20Theory/Dims/dim_employee.sql)
- [Dim Date](/Module%202/ETL%20Theory/Dims/dim_date.sql)
- [Dim Absence Type](/Module%202/ETL%20Theory/Dims/dim_absence_type.sql)
- [Dim Work Type](/Module%202/ETL%20Theory/Dims/dim_work_type.sql)

## Facts
- [Fact Employee At Date](/Module%202/ETL%20Theory/Facts/fact_employee_daily.sql)
- [Fact Employee at Month](/Module%202/ETL%20Theory/Facts/fact_employee_monthly.sql)

## Star Schema ERD
![star_schema](/Module%202/static/star_schema.png)


## DAILY
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8"/><style>
table {border: medium solid #6495ed;border-collapse: collapse;width: 100%;} th{font-family: monospace;border: thin solid #6495ed;padding: 5px;background-color: #D0E3FA;}th{text-align: left;}td{font-family: sans-serif;border: thin solid #6495ed;padding: 5px;text-align: center;}.odd{background:#e8edff;}img{padding:5px; border:solid; border-color: #dddddd #aaaaaa #aaaaaa #dddddd; border-width: 1px 2px 2px 1px; background-color:white;}</style>
</head>
<body>
<table><tr><th colspan="12"><pre><code>SELECT * FROM fact_employee_daily</code></pre></th></tr><tr><th>FACT_ID</th><th>DATE_KEY</th><th>EMPLOYEE_KEY</th><th>WORK_TYPE_KEY</th><th>ABSENCE_TYPE_KEY</th><th>REPORTED_HOURS</th><th>ABSENCE_HOURS</th><th>FIRST_JOIN</th><th>LAST_LEAVE</th><th>TOTAL_PRESENCE</th><th>WAS_PRESENT</th><th>WAS_ABSENT</th></tr><tr class="odd"><td>29</td><td>20,260,713</td><td>2</td><td>2</td><td>&nbsp;</td><td>8</td><td>0</td><td>2026-06-13 12:38:00.000</td><td>2026-06-13 14:15:00.000</td><td>1H 37M 0S</td><td>Y</td><td>N</td></tr>
<tr><td>30</td><td>20,260,713</td><td>2</td><td>2</td><td>&nbsp;</td><td>8</td><td>0</td><td>2026-06-13 12:38:00.000</td><td>2026-06-13 14:15:00.000</td><td>1H 37M 0S</td><td>Y</td><td>N</td></tr>
<tr class="odd"><td>31</td><td>20,260,713</td><td>1</td><td>2</td><td>&nbsp;</td><td>8</td><td>0</td><td>2026-06-13 12:37:00.000</td><td>2026-06-13 14:12:00.000</td><td>1H 34M 59S</td><td>Y</td><td>N</td></tr>
<tr><td>32</td><td>20,260,713</td><td>4</td><td>2</td><td>&nbsp;</td><td>8</td><td>0</td><td>2026-06-13 13:01:00.000</td><td>2026-06-13 14:02:00.000</td><td>1H 1M 0S</td><td>Y</td><td>N</td></tr>
<tr class="odd"><td>33</td><td>20,260,713</td><td>5</td><td>2</td><td>&nbsp;</td><td>8</td><td>0</td><td>2026-06-13 12:00:00.000</td><td>2026-06-13 17:00:00.000</td><td>5H 0M 0S</td><td>Y</td><td>N</td></tr>
<tr><td>34</td><td>20,260,713</td><td>3</td><td>2</td><td>&nbsp;</td><td>8</td><td>0</td><td>2026-06-13 13:01:00.000</td><td>2026-06-13 14:02:00.000</td><td>1H 1M 0S</td><td>Y</td><td>N</td></tr>
<tr class="odd"><td>35</td><td>20,260,714</td><td>2</td><td>2</td><td>&nbsp;</td><td>8</td><td>0</td><td>2026-06-13 12:38:00.000</td><td>2026-06-13 14:15:00.000</td><td>1H 37M 0S</td><td>Y</td><td>N</td></tr>
<tr><td>36</td><td>20,260,714</td><td>3</td><td>2</td><td>&nbsp;</td><td>8</td><td>0</td><td>2026-06-13 13:01:00.000</td><td>2026-06-13 14:02:00.000</td><td>1H 1M 0S</td><td>Y</td><td>N</td></tr>
<tr class="odd"><td>37</td><td>20,260,714</td><td>5</td><td>2</td><td>&nbsp;</td><td>8</td><td>0</td><td>2026-06-13 12:00:00.000</td><td>2026-06-13 17:00:00.000</td><td>5H 0M 0S</td><td>Y</td><td>N</td></tr>
<tr><td>38</td><td>20,260,714</td><td>4</td><td>2</td><td>&nbsp;</td><td>8</td><td>0</td><td>2026-06-13 13:01:00.000</td><td>2026-06-13 14:02:00.000</td><td>1H 1M 0S</td><td>Y</td><td>N</td></tr>
<tr class="odd"><td>39</td><td>20,260,714</td><td>1</td><td>2</td><td>&nbsp;</td><td>8</td><td>0</td><td>2026-06-13 12:37:00.000</td><td>2026-06-13 14:12:00.000</td><td>1H 34M 59S</td><td>Y</td><td>N</td></tr>
<tr><td>40</td><td>20,260,715</td><td>5</td><td>1</td><td>&nbsp;</td><td>8</td><td>0</td><td>2026-06-13 12:00:00.000</td><td>2026-06-13 17:00:00.000</td><td>5H 0M 0S</td><td>Y</td><td>N</td></tr>
<tr class="odd"><td>41</td><td>20,260,715</td><td>1</td><td>1</td><td>&nbsp;</td><td>8</td><td>0</td><td>2026-06-13 12:37:00.000</td><td>2026-06-13 14:12:00.000</td><td>1H 34M 59S</td><td>Y</td><td>N</td></tr>
<tr><td>42</td><td>20,260,715</td><td>4</td><td>1</td><td>&nbsp;</td><td>8</td><td>0</td><td>2026-06-13 13:01:00.000</td><td>2026-06-13 14:02:00.000</td><td>1H 1M 0S</td><td>Y</td><td>N</td></tr>
<tr class="odd"><td>43</td><td>20,260,715</td><td>3</td><td>1</td><td>&nbsp;</td><td>8</td><td>0</td><td>2026-06-13 13:01:00.000</td><td>2026-06-13 14:02:00.000</td><td>1H 1M 0S</td><td>Y</td><td>N</td></tr>
<tr><td>44</td><td>20,260,715</td><td>2</td><td>1</td><td>&nbsp;</td><td>8</td><td>0</td><td>2026-06-13 12:38:00.000</td><td>2026-06-13 14:15:00.000</td><td>1H 37M 0S</td><td>Y</td><td>N</td></tr>
<tr class="odd"><td>45</td><td>20,260,716</td><td>3</td><td>1</td><td>&nbsp;</td><td>8</td><td>0</td><td>2026-06-13 13:01:00.000</td><td>2026-06-13 14:02:00.000</td><td>1H 1M 0S</td><td>Y</td><td>N</td></tr>
<tr><td>46</td><td>20,260,716</td><td>3</td><td>1</td><td>&nbsp;</td><td>8</td><td>0</td><td>2026-06-13 13:01:00.000</td><td>2026-06-13 14:02:00.000</td><td>1H 1M 0S</td><td>Y</td><td>N</td></tr>
<tr class="odd"><td>47</td><td>20,260,716</td><td>4</td><td>1</td><td>&nbsp;</td><td>8</td><td>0</td><td>2026-06-13 13:01:00.000</td><td>2026-06-13 14:02:00.000</td><td>1H 1M 0S</td><td>Y</td><td>N</td></tr>
<tr><td>48</td><td>20,260,716</td><td>5</td><td>1</td><td>&nbsp;</td><td>8</td><td>0</td><td>2026-06-13 12:00:00.000</td><td>2026-06-13 17:00:00.000</td><td>5H 0M 0S</td><td>Y</td><td>N</td></tr>
<tr class="odd"><td>49</td><td>20,260,716</td><td>2</td><td>1</td><td>&nbsp;</td><td>8</td><td>0</td><td>2026-06-13 12:38:00.000</td><td>2026-06-13 14:15:00.000</td><td>1H 37M 0S</td><td>Y</td><td>N</td></tr>
<tr><td>50</td><td>20,260,716</td><td>1</td><td>1</td><td>&nbsp;</td><td>8</td><td>0</td><td>2026-06-13 12:37:00.000</td><td>2026-06-13 14:12:00.000</td><td>1H 34M 59S</td><td>Y</td><td>N</td></tr>
<tr class="odd"><td>51</td><td>20,260,717</td><td>3</td><td>1</td><td>&nbsp;</td><td>8</td><td>0</td><td>2026-06-13 13:01:00.000</td><td>2026-06-13 14:02:00.000</td><td>1H 1M 0S</td><td>Y</td><td>N</td></tr>
<tr><td>52</td><td>20,260,717</td><td>2</td><td>1</td><td>&nbsp;</td><td>8</td><td>0</td><td>2026-06-13 12:38:00.000</td><td>2026-06-13 14:15:00.000</td><td>1H 37M 0S</td><td>Y</td><td>N</td></tr>
<tr class="odd"><td>53</td><td>20,260,717</td><td>1</td><td>1</td><td>&nbsp;</td><td>8</td><td>0</td><td>2026-06-13 12:37:00.000</td><td>2026-06-13 14:12:00.000</td><td>1H 34M 59S</td><td>Y</td><td>N</td></tr>
<tr><td>54</td><td>20,260,717</td><td>5</td><td>1</td><td>&nbsp;</td><td>8</td><td>0</td><td>2026-06-13 12:00:00.000</td><td>2026-06-13 17:00:00.000</td><td>5H 0M 0S</td><td>Y</td><td>N</td></tr>
<tr class="odd"><td>55</td><td>20,260,717</td><td>4</td><td>1</td><td>&nbsp;</td><td>8</td><td>0</td><td>2026-06-13 13:01:00.000</td><td>2026-06-13 14:02:00.000</td><td>1H 1M 0S</td><td>Y</td><td>N</td></tr>
</table></body></html>

## MONTHLY
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8"/><style>
table {border: medium solid #6495ed;border-collapse: collapse;width: 100%;} th{font-family: monospace;border: thin solid #6495ed;padding: 5px;background-color: #D0E3FA;}th{text-align: left;}td{font-family: sans-serif;border: thin solid #6495ed;padding: 5px;text-align: center;}.odd{background:#e8edff;}img{padding:5px; border:solid; border-color: #dddddd #aaaaaa #aaaaaa #dddddd; border-width: 1px 2px 2px 1px; background-color:white;}</style>
</head>
<body>
<table><tr><th colspan="12"><pre><code>SELECT * FROM fact_employee_monthly</code></pre></th></tr><tr><th>FACT_ID</th><th>EMPLOYEE_KEY</th><th>YEAR_NUMBER</th><th>MONTH_NUMBER</th><th>TOTAL_REPORTED_HOURS</th><th>TOTAL_ABSENCE_HOURS</th><th>MEDICAL_LEAVE_DAYS</th><th>ANNUAL_LEAVE_DAYS</th><th>PUBLIC_HOLIDAY_DAYS</th><th>EXAM_LEAVE_HOURS</th><th>ATTENDANCE_DAYS</th><th>PRESENCE_PERCENTAGE</th></tr><tr class="odd"><td>1</td><td>2</td><td>2,026</td><td>7</td><td>48</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>6</td><td>100</td></tr>
<tr><td>2</td><td>1</td><td>2,026</td><td>7</td><td>40</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>5</td><td>100</td></tr>
<tr class="odd"><td>3</td><td>4</td><td>2,026</td><td>7</td><td>40</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>5</td><td>100</td></tr>
<tr><td>4</td><td>5</td><td>2,026</td><td>7</td><td>40</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>5</td><td>100</td></tr>
<tr class="odd"><td>5</td><td>3</td><td>2,026</td><td>7</td><td>48</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>6</td><td>100</td></tr>
<tr><td>6</td><td>2</td><td>2,026</td><td>7</td><td>48</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>6</td><td>100</td></tr>
<tr class="odd"><td>7</td><td>1</td><td>2,026</td><td>7</td><td>40</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>5</td><td>100</td></tr>
<tr><td>8</td><td>4</td><td>2,026</td><td>7</td><td>40</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>5</td><td>100</td></tr>
<tr class="odd"><td>9</td><td>5</td><td>2,026</td><td>7</td><td>40</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>5</td><td>100</td></tr>
<tr><td>10</td><td>3</td><td>2,026</td><td>7</td><td>48</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>6</td><td>100</td></tr>
</table></body></html>