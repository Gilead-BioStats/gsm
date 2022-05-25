# Release Description
<!--- Summarize what is being released.  -->

## Assessments Updated
<!--- List all new/updated assessments and provide a brief description of the updates --->
<!--- Add a section for "Other updates" if there are updates that are not related to a specific assessment --->

## Milestone
<!--- Link to the milestone for the release. ---> 
<!--- Make sure all relevant issues/PRs are included on the linked pages. --->
Milestone: [v1.0.0](https://github.com/Gilead-BioStats/gsm/milestone/1)

# Overall Risk Assessment 
<!--- Complete the following Risk Assessment for this Release-->
<!--- Risk should generally be the highest risk among the `fix` PRs included in the release--->
Overall Risk: Low/Medium/High

Notes: 
<!--- provide a quick description of the overall risk assessment -->

## Assessment 1 Risk
<!--- Make a separate section accessing risk for each assessment and "other" update. -->
<!--- If selected, fill out the QC checklist in a comment on this PR. Add one comment per Assessment --->
Overall Risk: Low/Medium/High
Mitigation Strategy:
- [ ] Qualification Testing
- [ ] Unit Testing
- [ ] Code Review
- [ ] QC Checklist
- [ ] Automated Testing

Notes: 
<!--- provide a quick description of what was done and why the -->
<!--- risk level and mitigation strategies were chosen -->

# Release Checklist
<!--- Fill out the following Release checklist -->

- [ ] Version number has been updated in `DESCRIPTION`
- [ ] NEWS.md has been updated
- [ ] Ensure all unit tests are passing
- [ ] Ensure all qualification tests are passing and report has been rerun
- [ ] All QC Checklists in this PR are complete
- [ ] GitHub actions on this PR are all passing
- [ ] Formatted code with `styler`
- [ ] Run `spell_check()`
- [ ] Completed QC of documentation including `README.md` and relevant Vignettes
- [ ] Build site `pkgdown::build_site()` and check that all affected examples are displayed correctly and that all new functions occur on the "[Reference](https://silver-potato-cfe8c2fb.pages.github.io/reference/index.html)" page. 
- [ ] Draft GitHub release created using automatic template and updated with additional details. Remember to click "release" after PR is merged.  

