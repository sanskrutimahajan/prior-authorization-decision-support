# End-to-end verification — 12 October 2026

Result: PASS for the tested canvas app workflow in Power Apps Studio preview. The app remains saved and unpublished. No application fixes were required during this test.

Test case: `DEMO-E2E-1012`, fictional patient `Demo Workflow Test`, reviewer `reviewer.qa@example.com`. All case details and decisions are demonstration data.

| Check | Observed result |
| --- | --- |
| Controlled selections | Aetna offered Lumbar Epidural Steroid Injection; that treatment offered Lumbar Radiculopathy. Treatment and diagnosis were disabled until their preceding selections were made. |
| Create and save | Save succeeded. Dashboard total increased from 48 to 49; Pending increased from 9 to 10. |
| Open saved case | Correct patient, payer, treatment, diagnosis and Pending status displayed. |
| Required decision reason | A transition without a reason was blocked with a validation message. |
| Incomplete evidence | Five evidence flags enabled, PT 4 weeks, symptoms 2 months: 6/8 Met, 75% readiness. Both duration requirements were Missing; approval disabled. |
| Evidence persistence | Returned through the dashboard and reopened: all five flags, durations and reviewer persisted. |
| Reviewer transition | Pending → In Review saved, with reviewer, reason, notes, UTC timestamp and Applied outcome in history. |
| AI evidence review | Fictional lumbar document produced five Yes values, PT 6 weeks and symptoms 3 months, with excerpts. Save required confirmation; an edited value blocked saving until current values were confirmed. |
| AI evidence save | Reviewed evidence saved to the case; status remained In Review and analysis was required again. |
| Complete evidence | 8/8 Met, 100% readiness. |
| Single missing requirement | PT 5 weeks with other evidence complete: 7/8 Met, 88% displayed readiness, approval disabled. |
| Normal keyboard edit | Editing PT from 6 to 5 and leaving the input immediately invalidated the prior 100% result and disabled approval. |
| Final reviewer decision | Restored PT 6, rechecked 8/8, entered reason and notes, then saved In Review → Approved. |
| Audit history | Both transitions appeared newest first, with separate reasons and notes and Applied outcomes. |
| Dashboard update | Final totals: 49 cases, 9 Pending, 9 In Review, 26 Approved, 5 Denied. Test row showed Approved. |
| Final persistence | Reopened the approved case after dashboard refresh; Approved status and both history entries persisted. |

## Scope

This verifies the primary application workflow, including the AI-assisted evidence path, using the unpublished draft and Dataverse demonstration records. It is not production clinical validation, a concurrency/load test, or an exhaustive accessibility/security assessment. The optional Power Automate notification remains an unpublished draft and was not run. Power BI refresh was not part of this application test.

The test record is retained for review. Screenshots and textual observations are stored alongside this document. Readiness percentages are displayed as whole numbers (7/8 = 87.5%, displayed as 88%).

## Subsequent release

The canvas app was published after this test on 12 October 2026. References above to draft/unpublished describe the test session, not the subsequent release. A fresh native download supplied the repository screen source.
