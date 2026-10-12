# Setup

## Environment

Use a Power Apps environment with Dataverse and appropriate maker/table access. The app download refers to the original custom table names with publisher prefix `cr36f_`. Consult `data/dataverse-schema.json` for the column names and types. Provision the three custom tables before rebinding the app data sources. This repository is not a solution export that creates these tables automatically.

Cases use text fields for case/patient IDs, patient name, payer, treatment, diagnosis and reviewer; multiline clinical notes; optional date fields; evidence Yes/No fields; integer Physical Therapy Weeks and Symptoms Duration Months; and a Status choice. Required Patient ID and Patient Name must be populated. Recreate the business Status options as Pending, In Review, Approved and Denied. Do not confuse the custom Status with Dataverse system state/status reason.

Requirements use the columns shown in the schema, including Requirement Name, payer/treatment/diagnosis, description, required evidence, Rule Type choice, Minimum Duration integer, Is Required and Active Yes/No. Payer, Treatment and Diagnosis are required. The evaluation is dispatched by Requirement Name; Rule Type is used for descriptive display rather than as a generic rules engine.

## Reconstruct the canvas app

Use the four screen definitions and App definition in `src/canvas` as the Studio authoring reference. Create the Dataverse tables first, add all three table connections, and recreate/bind the AI Builder prompt using `ai/prompt.txt`. The source does not provision these dependencies. Match logical names and choice values; update references if a different publisher prefix is used. Run App checker and the demo checks before publishing. See [export status](export-status.md) for package availability.

## Demo rules

Import `data/demo-requirements.csv` with explicit column mapping, or use the included demo seed Power Fx in a disposable development environment. Do not trust localized display labels for Yes/No fields: set actual Active/Is Required values to boolean true and verify the resulting evaluation. The existing environment had misleading legacy display labels; matching now uses `Active = true`.

The seed file is an administrative setup aid. It is not wired into the completed app. It upserts exact-name rules and normalizes the five CA00x demo records’ patient names, notes and reviewer addresses. Run it only in a demo environment with those records, on a temporary setup control; remove that control afterward. It does not create the case table or all case records.

Supported Requirement Name values:

- Confirmed Diagnosis
- Imaging Available
- Physical Therapy
- Medication Trial
- Specialist Evaluation
- Symptoms Duration
- Functional Limitation
- Conservative Treatment Failed

Use the CSV’s exact text combinations for matching. Aetna/spine, Blue Cross/spine and United Health/knee have eight criteria each; the two fracture combinations have three, and the Cigna chemotherapy combination has two. Every threshold is fabricated for demonstrating application behavior, including the six-week and three-month examples.

## Demo data

Create records through the app using `Demo Patient` names, invented IDs and `reviewer@example.com`. Use only invented notes, dates and evidence. Keep the demo small. The screenshots contain demo records and do not establish clinical validity.

## Export maintenance

After changing the app in Studio, save and download a fresh `.msapp`, then refresh the extracted `src/canvas` files and selected formulas. Power Apps’ generated YAML cautions that it is intended for review and minor preview edits; use Studio for app authoring. A local extraction is not an independent compilation or clean-environment deployment test.

## Decision records and migration

Create `Authorization Decisions` (`cr36f_authorizationdecision`) using the exported schema. Use `Decision Name` as the primary name and an `Authorization Case` lookup targeting `cr36f_priorauthorizationcase` (not the unrelated legacy table ending in `case1`). Include Decision Time (Date and time, User Local), Previous Status, New Status, Reviewer, Reason (1000 characters), Reviewer Notes (multiline, 2000 characters) and Outcome. Decision Name is populated with a GUID for new entries. Bind this third data source in Studio and refresh it after changing columns.

Each decision is created with Outcome Pending before the case is updated. A completed save changes Outcome to Applied; a rejected case update changes it to Failed. If finalization fails after the case changes, the app explicitly reports that reconciliation is needed. An administrator should compare the case and its decision records before repairing an incomplete save. Do not automatically resubmit a pending decision. These are separate writes, not an atomic Dataverse transaction. Organization-level auditing is a separate configuration and is not claimed as enabled.

Keep the optional legacy `Decision History` multiline case column (100000 characters) for the existing backup and migration. New status changes do not append to it. `src/power-fx/migrate-decision-history.fx` is an administrative setup aid for the earlier known text format, not a production migration engine. It links each imported record to its case and preserves its original UTC time, reviewer, reason and notes. It checks a deterministic name before inserting, allowing sequential reruns without reimporting the same entry. It does not reconstruct decisions that were never recorded. Run only on known demo data using a temporary setup control, verify the rows, then restore/remove the control before saving the final app. The published app has no migration action wired in. Original text is retained.

A status change requires a reviewer address and reason; notes are optional. Repeating the current status does not create a new history entry. The app checks the latest saved status before creating a decision. The history view queries linked decision rows newest first and displays UTC times and outcomes. Reviewer identity is entered text; authenticated identity, enforced append-only security, atomic writes and full concurrency guarantees remain future work.

## Controlled selections and dashboard filters

Payer, treatment and diagnosis selections come from active requirement rows. Treatments depend on payer; diagnoses depend on payer and treatment. Upstream changes reset downstream selections. Treatment and diagnosis are disabled until their prerequisite is selected. All three form cards are required. Populate the requirements before demonstrating case creation.

Dashboard search matches the beginning of a case number or patient name. Filters combine status, payer, reviewer-email prefix and urgency. Clear resets them all. The filtered list sorts by case number and shows an explicit empty state; summary counts continue to show all cases. Payer choices come from the case data. Distinct option generation and concatenated history rendering need a larger-dataset/delegation review before scale-up.
