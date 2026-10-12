# Reviewer notifications

Power Automate component: **Prior Authorization - Reviewer Notification**.

## Configured workflow

1. Watch added or modified Dataverse Authorization Decisions, filtering modifications on `cr36f_outcome`.
2. Continue when Outcome is Applied, New Status is In Review and Previous Status differs from In Review.
3. Retrieve the linked case number, assigned reviewer and current status.
4. Check that the case is still In Review and its assigned reviewer matches the decision reviewer, ignoring case and surrounding spaces.
5. Send an Office 365 Outlook notification to that reviewer. The other branch takes no action.

Recipient checks exclude example.com demo recipients and comma/semicolon lists. The message contains case number, status, UTC event time and instructions to open the app and search for the case. It excludes patient names, birth dates, clinical notes, diagnosis, treatment and reviewer notes.

## Setup and validation

`power-automate/reviewer-notification.source.json` contains the designer Code view source, not an importable solution. Recreate the trigger/actions in a solution with Dataverse and Outlook connection references. Map the case lookup and validate Status labels in the destination environment. The saved configuration passed Flow checker with 0 errors and 0 warnings.

The saved flow is a draft. Publish and enable it in the destination environment when notification delivery is authorized. Use one fictional case and an approved test mailbox to check one Pending-to-In Review notification, then check suppression for Pending/Failed outcomes, other statuses, example.com recipients and stale assignments. Checker success alone does not establish email delivery.

## Limitations and enhancements

Current status is checked at lookup time; it is not atomic with sending. Connector retries or repeated Applied updates may create duplicates. Durable deduplication, a notification ledger, failure alerts, authenticated reviewer assignment and reminders are future enhancements. Basic recipient checks do not establish reviewer identity or mailbox validity. No historical notification backfill is implemented.
