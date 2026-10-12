# Power BI reporting

The **Prior Authorization Operations** report adds an operational reporting layer to the Power Apps workflow. It reads the existing Dataverse Cases and Decisions tables; report interactions do not change case records.

## Implemented pages

- **Case Overview:** total, open, approved and urgent case cards; status and payer bar charts; case list with assigned reviewer and urgency; payer and status slicers.
- **Decision Activity:** applied-decision and reconciliation cards; recorded status-change bar chart and case-linked history table with exact decision timestamps, previous/new status, outcome and reviewer; payer slicer propagated through the case relationship.



## Architecture

Power Apps → Dataverse → Power Query import → Power BI semantic model → report.

The model contains Cases (one row per case) and Decisions (one row per recorded status change). An active, single-direction one-to-many relationship connects `Cases[Case ID]` to `Decisions[Case ID]`. Payer selections on Cases filter the linked decision rows.

Reporting imports case identifiers, payer/treatment/diagnosis labels, status, assigned reviewer, urgency, creation dates, decision identifiers, timestamps and status/outcome fields. Patient names, patient identifiers, dates of birth, clinical notes, reasons and reviewer notes are excluded. Reviewer values in the current demo are `reviewer@example.com`.

## Source and setup

The repository includes Cases/Decisions Power Query, DAX measures, and a fresh 12 October report-definition JSON capture for layout reference. It is not a complete PBIP project. The refined native report was downloaded on 12 October and its report-definition source extracted. Native PBIX/PQT files are retained locally outside this public version because their embedded deployment metadata has not been made portable.

Create a Text parameter `DataverseHost` using `power-bi/DataverseHost.pq`, set it to your Dataverse hostname and sign in with your own organizational account. Create Cases and Decisions queries from the supplied M source, verify column names, add the Case ID relationship and measures, and recreate the two report pages. Refresh the semantic model after changing Dataverse data. No credentials, scheduled refresh or public report access are supplied.

## Metric definitions

| Metric | Definition |
| --- | --- |
| Total Cases | Number of Cases rows in the current filter context |
| Open Cases | Cases whose current status is Pending or In Review |
| Approved Cases | Cases whose current status is Approved |
| Urgent Cases | Cases whose urgency is Urgent |
| Applied Decisions | Decision records whose save outcome is Applied |
| Decisions Needing Reconciliation | Decision records with outcome Pending or Failed |

Case status cards describe the current snapshot. Applied Decisions counts events, including repeated changes to the same case, rather than distinct approved cases. Status and urgency measures intersect their stated conditions with the current selections using KEEPFILTERS. Payer and status slicers narrow the case metrics; the decision page has its own payer slicer. Readiness is evaluated within Power Apps and is not a stored reporting metric.

## Demo verification

Verified against the existing demo data on 8 October 2026:

- Eight cases: five Approved, one Denied, one In Review, one Pending; two open and one urgent.
- Six Applied decision records and zero Pending/Failed decision records.
- Aetna selection on Case Overview: three cases, zero open, three approved, zero urgent; case list narrowed to DEMO006–DEMO008.
- Aetna selection on Decision Activity: four Applied records, all linked to DEMO008, and zero needing reconciliation.
- Clearing selections restored the unfiltered totals. The decision table was sorted by timestamp and both pages were saved and viewed in reading mode.
- Native download contains both report pages and a DataModel payload.

## Refinement verification — 9 October 2026, before data expansion

- Unfiltered Case Overview: total 8, open 2, approved 5, urgent 1; all eight case rows visible.
- Approved status: total 5, open 0, approved 5, urgent 1.
- Denied status: total 1, open 0, approved 0, urgent 0.
- Aetna plus Approved: total 3, open 0, approved 3, urgent 0; only DEMO006–DEMO008 displayed.
- Decision Activity: six Applied events; new-status distribution Approved 2, In Review 2, Denied 1, Pending 1.
- Aetna decision selection: four Applied events linked to DEMO008, zero needing reconciliation.
- Cigna decision selection: both cards zero and no history rows, rather than fabricated history.
- Cleared filters and saved both cloud pages; inspected reading-mode layout for overlaps and clipped rows.

## Expanded data verification — 9 October 2026

- Dataverse and refreshed Case Overview: 48 cases, 18 open, 25 approved, 9 urgent.
- Status distribution: Approved 25, In Review 9, Pending 9, Denied 5.
- Payer distribution: Aetna 10, Blue Cross 16, Cigna 14, United Health 8.
- Decision Activity: 102 Applied events and zero needing reconciliation.
- Event distribution by new status: Pending 41, In Review 34, Approved 22, Denied 5.
- Cigna filter: 14 cases, 7 open, 5 approved, 3 urgent; decision page showed 28 Applied events.
- Cleared both payer filters. Decision history displays newest timestamps first; the report was saved and inspected in reading mode.
- The temporary data-seeding action was removed and the original new-case navigation restored and saved in Power Apps Studio.

## Refresh and limitations

The model uses **Import mode**, so it is a saved snapshot rather than a live stream from Power Apps. The initial Dataverse import succeeded. No scheduled refresh is configured. After changes in Power Apps, refresh the semantic model from its workspace menu, wait for successful completion, and then refresh report visuals. Refreshing visuals alone does not reload Dataverse. A subsequent manual Dataverse source refresh was successfully verified on 9 October 2026 after adding 40 cases and 96 events.

Forty-two of the 48 cases have recorded decision events. Forty cases contain seeded illustrative histories, as explained in [demo data](demo-data.md). This partial, demonstration history does not support reliable turnaround-time, SLA or historical approval-rate conclusions. Reviewer fields are entered demo labels, not authenticated workload ownership. No row-level security, report embedding, scheduled delivery, or automated alerts are implemented.

## Future enhancements

- Configure and validate scheduled refresh and refresh-failure monitoring.
- Add a date dimension and period comparisons after collecting representative data.
- Persist evidence/readiness snapshots for historical analysis.
- Add reliable case lifecycle timestamps before introducing aging, turnaround or SLA measures.
- Introduce authenticated reviewer identity and role-based access before reporting real workloads.
- Embed the report in the application and add suitable licensing/access controls.

## Demo-data disclaimer

All included records and policy rules are invented for demonstration. Payer names are illustrative labels and do not represent actual payer policies. The report is not clinical guidance and must not determine real patient authorization outcomes.

Connector reference: [Microsoft Dataverse connector](https://learn.microsoft.com/en-us/power-query/connectors/dataverse).
