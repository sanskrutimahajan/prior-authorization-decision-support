# AI evidence assistance

The published canvas app includes an evidence-review screen backed by the AI Builder prompt in `ai/prompt.txt`. Configure the prompt and its destination connection in Studio.

Supported scope: Lumbar Radiculopathy and Lumbar Epidural Steroid Injection. Input is pasted document text. Output contains five evidence flags, physical-therapy weeks, symptom-duration months and source excerpts. Unknown or ambiguous evidence requires reviewer resolution. Excerpts are checked against the input text. Saving requires resolved values and confirmation tied to the reviewed values; editing invalidates confirmation. Saving updates structured evidence, resets readiness analysis and does not change case status.

The prompt is a reference definition rather than an importable AI Builder solution. Model observed during authoring: GPT-4.1 mini. Evaluations in `ai/evaluation` cover complete evidence, missing/negated evidence, conflicting evidence and unsupported scope. See the end-to-end test for confirmation and persistence checks. Document input and raw extraction are not retained as a permanent evidence provenance record.

Future work: PDF/OCR input, broader evaluated scenarios, durable provenance, representative evaluation datasets and governed model/prompt versioning. AI output is assistance and requires human review.
