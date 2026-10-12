# Expanded demonstration data

Forty additional fictional cases were saved to Dataverse on 9 October 2026, using the administrative formula in `src/power-fx/portfolio-data-seed.fx`. Their deterministic case numbers are DEMO-BI-001 through DEMO-BI-040. The 40-row manifest is `data/portfolio-demo-cases.csv`.

The cases use the six existing payer/treatment/diagnosis combinations. No new policy definitions or unsupported requirement names were introduced. Approved scenarios have all five evidence flags selected, six physical-therapy weeks and three symptom months. Other scenarios include incomplete evidence. All reviewer addresses use example.com.

Each case has an intake event; non-pending cases have an In Review event; approved/denied cases have a final event. These are seeded illustrative histories, not logs of real patient reviews. Seed timestamps are generated at execution with ordered seconds for the stages. Dataverse creation timestamps remain the actual creation time; no historical case creation dates were fabricated.

The seed checks case numbers and decision names before creating rows. It is intended for a small demonstration environment, not concurrent production imports. After execution, the temporary authoring action was restored to the original new-case navigation and saved. The seed is not attached to a published user action.

Expected additions: 20 Approved, 8 In Review, 8 Pending, 4 Denied; 8 urgent cases; 96 linked Applied events. The existing eight cases and six decision events are retained.

A zero reconciliation count is valid: all seeded writes have outcome Applied. Failed or Pending outcomes were not fabricated to make the dashboard appear busier.

## Verified result

Dataverse and the manually refreshed Power BI report both showed 48 cases: 25 Approved, 9 In Review, 9 Pending and 5 Denied. The report showed 18 open cases, 9 urgent cases and 102 Applied decision events. Cigna filtering returned 14 cases and 28 events, confirming that the added data participates in the case-to-decision relationship. Both report pages were left unfiltered, with decision history sorted newest first.

No new PBIX download or ZIP rebuild was performed; the cloud report and expanded screenshots are current.
