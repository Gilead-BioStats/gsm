# Generated table has correct structure and content

    Code
      output
    Output
      <h2>Study Status</h2>
      <label class="toggle">
        <input class="toggle-checkbox btn-show-details" type="checkbox"
          data-shown-table="study_table"
          data-hidden-table="study_table_hide"
          data-hidden="false"
          onclick="toggleTables(this)">
        <div class="toggle-switch"></div>
        <span class="toggle-label">Show Details</span>
      </label>
      <div id="study_table" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
        <style>#study_table table {
        font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
        -webkit-font-smoothing: antialiased;
        -moz-osx-font-smoothing: grayscale;
      }
      
      #study_table thead, #study_table tbody, #study_table tfoot, #study_table tr, #study_table td, #study_table th {
        border-style: none;
      }
      
      #study_table p {
        margin: 0;
        padding: 0;
      }
      
      #study_table .gt_table {
        display: table;
        border-collapse: collapse;
        line-height: normal;
        margin-left: auto;
        margin-right: auto;
        color: #333333;
        font-size: 16px;
        font-weight: normal;
        font-style: normal;
        background-color: #FFFFFF;
        width: auto;
        border-top-style: solid;
        border-top-width: 2px;
        border-top-color: #A8A8A8;
        border-right-style: none;
        border-right-width: 2px;
        border-right-color: #D3D3D3;
        border-bottom-style: solid;
        border-bottom-width: 2px;
        border-bottom-color: #A8A8A8;
        border-left-style: none;
        border-left-width: 2px;
        border-left-color: #D3D3D3;
      }
      
      #study_table .gt_caption {
        padding-top: 4px;
        padding-bottom: 4px;
      }
      
      #study_table .gt_title {
        color: #333333;
        font-size: 125%;
        font-weight: initial;
        padding-top: 2px;
        padding-bottom: 2px;
        padding-left: 5px;
        padding-right: 5px;
        border-bottom-color: #FFFFFF;
        border-bottom-width: 0;
      }
      
      #study_table .gt_subtitle {
        color: #333333;
        font-size: 85%;
        font-weight: initial;
        padding-top: 1px;
        padding-bottom: 3px;
        padding-left: 5px;
        padding-right: 5px;
        border-top-color: #FFFFFF;
        border-top-width: 0;
      }
      
      #study_table .gt_heading {
        background-color: #FFFFFF;
        text-align: center;
        border-bottom-color: #FFFFFF;
        border-left-style: none;
        border-left-width: 1px;
        border-left-color: #D3D3D3;
        border-right-style: none;
        border-right-width: 1px;
        border-right-color: #D3D3D3;
      }
      
      #study_table .gt_bottom_border {
        border-bottom-style: solid;
        border-bottom-width: 2px;
        border-bottom-color: #D3D3D3;
      }
      
      #study_table .gt_col_headings {
        border-top-style: solid;
        border-top-width: 2px;
        border-top-color: #D3D3D3;
        border-bottom-style: solid;
        border-bottom-width: 2px;
        border-bottom-color: #D3D3D3;
        border-left-style: none;
        border-left-width: 1px;
        border-left-color: #D3D3D3;
        border-right-style: none;
        border-right-width: 1px;
        border-right-color: #D3D3D3;
      }
      
      #study_table .gt_col_heading {
        color: #333333;
        background-color: #FFFFFF;
        font-size: 100%;
        font-weight: normal;
        text-transform: inherit;
        border-left-style: none;
        border-left-width: 1px;
        border-left-color: #D3D3D3;
        border-right-style: none;
        border-right-width: 1px;
        border-right-color: #D3D3D3;
        vertical-align: bottom;
        padding-top: 2.5px;
        padding-bottom: 3.5px;
        padding-left: 5px;
        padding-right: 5px;
        overflow-x: hidden;
      }
      
      #study_table .gt_column_spanner_outer {
        color: #333333;
        background-color: #FFFFFF;
        font-size: 100%;
        font-weight: normal;
        text-transform: inherit;
        padding-top: 0;
        padding-bottom: 0;
        padding-left: 4px;
        padding-right: 4px;
      }
      
      #study_table .gt_column_spanner_outer:first-child {
        padding-left: 0;
      }
      
      #study_table .gt_column_spanner_outer:last-child {
        padding-right: 0;
      }
      
      #study_table .gt_column_spanner {
        border-bottom-style: solid;
        border-bottom-width: 2px;
        border-bottom-color: #D3D3D3;
        vertical-align: bottom;
        padding-top: 2.5px;
        padding-bottom: 2.5px;
        overflow-x: hidden;
        display: inline-block;
        width: 100%;
      }
      
      #study_table .gt_spanner_row {
        border-bottom-style: hidden;
      }
      
      #study_table .gt_group_heading {
        padding-top: 4px;
        padding-bottom: 4px;
        padding-left: 5px;
        padding-right: 5px;
        color: #333333;
        background-color: #FFFFFF;
        font-size: 100%;
        font-weight: initial;
        text-transform: inherit;
        border-top-style: solid;
        border-top-width: 2px;
        border-top-color: #D3D3D3;
        border-bottom-style: solid;
        border-bottom-width: 2px;
        border-bottom-color: #D3D3D3;
        border-left-style: none;
        border-left-width: 1px;
        border-left-color: #D3D3D3;
        border-right-style: none;
        border-right-width: 1px;
        border-right-color: #D3D3D3;
        vertical-align: middle;
        text-align: left;
      }
      
      #study_table .gt_empty_group_heading {
        padding: 0.5px;
        color: #333333;
        background-color: #FFFFFF;
        font-size: 100%;
        font-weight: initial;
        border-top-style: solid;
        border-top-width: 2px;
        border-top-color: #D3D3D3;
        border-bottom-style: solid;
        border-bottom-width: 2px;
        border-bottom-color: #D3D3D3;
        vertical-align: middle;
      }
      
      #study_table .gt_from_md > :first-child {
        margin-top: 0;
      }
      
      #study_table .gt_from_md > :last-child {
        margin-bottom: 0;
      }
      
      #study_table .gt_row {
        padding-top: 4px;
        padding-bottom: 4px;
        padding-left: 5px;
        padding-right: 5px;
        margin: 10px;
        border-top-style: solid;
        border-top-width: 1px;
        border-top-color: #D3D3D3;
        border-left-style: none;
        border-left-width: 1px;
        border-left-color: #D3D3D3;
        border-right-style: none;
        border-right-width: 1px;
        border-right-color: #D3D3D3;
        vertical-align: middle;
        overflow-x: hidden;
      }
      
      #study_table .gt_stub {
        color: #333333;
        background-color: #FFFFFF;
        font-size: 100%;
        font-weight: initial;
        text-transform: inherit;
        border-right-style: solid;
        border-right-width: 2px;
        border-right-color: #D3D3D3;
        padding-left: 5px;
        padding-right: 5px;
      }
      
      #study_table .gt_stub_row_group {
        color: #333333;
        background-color: #FFFFFF;
        font-size: 100%;
        font-weight: initial;
        text-transform: inherit;
        border-right-style: solid;
        border-right-width: 2px;
        border-right-color: #D3D3D3;
        padding-left: 5px;
        padding-right: 5px;
        vertical-align: top;
      }
      
      #study_table .gt_row_group_first td {
        border-top-width: 2px;
      }
      
      #study_table .gt_row_group_first th {
        border-top-width: 2px;
      }
      
      #study_table .gt_summary_row {
        color: #333333;
        background-color: #FFFFFF;
        text-transform: inherit;
        padding-top: 4px;
        padding-bottom: 4px;
        padding-left: 5px;
        padding-right: 5px;
      }
      
      #study_table .gt_first_summary_row {
        border-top-style: solid;
        border-top-color: #D3D3D3;
      }
      
      #study_table .gt_first_summary_row.thick {
        border-top-width: 2px;
      }
      
      #study_table .gt_last_summary_row {
        padding-top: 4px;
        padding-bottom: 4px;
        padding-left: 5px;
        padding-right: 5px;
        border-bottom-style: solid;
        border-bottom-width: 2px;
        border-bottom-color: #D3D3D3;
      }
      
      #study_table .gt_grand_summary_row {
        color: #333333;
        background-color: #FFFFFF;
        text-transform: inherit;
        padding-top: 4px;
        padding-bottom: 4px;
        padding-left: 5px;
        padding-right: 5px;
      }
      
      #study_table .gt_first_grand_summary_row {
        padding-top: 4px;
        padding-bottom: 4px;
        padding-left: 5px;
        padding-right: 5px;
        border-top-style: double;
        border-top-width: 6px;
        border-top-color: #D3D3D3;
      }
      
      #study_table .gt_last_grand_summary_row_top {
        padding-top: 4px;
        padding-bottom: 4px;
        padding-left: 5px;
        padding-right: 5px;
        border-bottom-style: double;
        border-bottom-width: 6px;
        border-bottom-color: #D3D3D3;
      }
      
      #study_table .gt_striped {
        background-color: rgba(128, 128, 128, 0.05);
      }
      
      #study_table .gt_table_body {
        border-top-style: solid;
        border-top-width: 2px;
        border-top-color: #D3D3D3;
        border-bottom-style: solid;
        border-bottom-width: 2px;
        border-bottom-color: #D3D3D3;
      }
      
      #study_table .gt_footnotes {
        color: #333333;
        background-color: #FFFFFF;
        border-bottom-style: none;
        border-bottom-width: 2px;
        border-bottom-color: #D3D3D3;
        border-left-style: none;
        border-left-width: 2px;
        border-left-color: #D3D3D3;
        border-right-style: none;
        border-right-width: 2px;
        border-right-color: #D3D3D3;
      }
      
      #study_table .gt_footnote {
        margin: 0px;
        font-size: 90%;
        padding-top: 2px;
        padding-bottom: 2px;
        padding-left: 5px;
        padding-right: 5px;
      }
      
      #study_table .gt_sourcenotes {
        color: #333333;
        background-color: #FFFFFF;
        border-bottom-style: none;
        border-bottom-width: 2px;
        border-bottom-color: #D3D3D3;
        border-left-style: none;
        border-left-width: 2px;
        border-left-color: #D3D3D3;
        border-right-style: none;
        border-right-width: 2px;
        border-right-color: #D3D3D3;
      }
      
      #study_table .gt_sourcenote {
        font-size: 90%;
        padding-top: 2px;
        padding-bottom: 2px;
        padding-left: 5px;
        padding-right: 5px;
      }
      
      #study_table .gt_left {
        text-align: left;
      }
      
      #study_table .gt_center {
        text-align: center;
      }
      
      #study_table .gt_right {
        text-align: right;
        font-variant-numeric: tabular-nums;
      }
      
      #study_table .gt_font_normal {
        font-weight: normal;
      }
      
      #study_table .gt_font_bold {
        font-weight: bold;
      }
      
      #study_table .gt_font_italic {
        font-style: italic;
      }
      
      #study_table .gt_super {
        font-size: 65%;
      }
      
      #study_table .gt_footnote_marks {
        font-size: 75%;
        vertical-align: 0.4em;
        position: initial;
      }
      
      #study_table .gt_asterisk {
        font-size: 100%;
        vertical-align: 0;
      }
      
      #study_table .gt_indent_1 {
        text-indent: 5px;
      }
      
      #study_table .gt_indent_2 {
        text-indent: 10px;
      }
      
      #study_table .gt_indent_3 {
        text-indent: 15px;
      }
      
      #study_table .gt_indent_4 {
        text-indent: 20px;
      }
      
      #study_table .gt_indent_5 {
        text-indent: 25px;
      }
      
      #study_table .katex-display {
        display: inline-flex !important;
        margin-bottom: 0.75em !important;
      }
      
      #study_table div.Reactable > div.rt-table > div.rt-thead > div.rt-tr.rt-tr-group-header > div.rt-th-group:after {
        height: 0px !important;
      }
      </style>
        <table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
        
        <tbody class="gt_table_body">
          <tr><td headers="Description" class="gt_row gt_left">Nickname</td>
      <td headers="Value" class="gt_row gt_right">Nickname</td></tr>
        </tbody>
        
        
      </table>
      </div>
      <div id="study_table_hide" style="display: none;">
        <div id="study_table_hide_gt" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
          <style>#study_table_hide_gt table {
        font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
        -webkit-font-smoothing: antialiased;
        -moz-osx-font-smoothing: grayscale;
      }
      
      #study_table_hide_gt thead, #study_table_hide_gt tbody, #study_table_hide_gt tfoot, #study_table_hide_gt tr, #study_table_hide_gt td, #study_table_hide_gt th {
        border-style: none;
      }
      
      #study_table_hide_gt p {
        margin: 0;
        padding: 0;
      }
      
      #study_table_hide_gt .gt_table {
        display: table;
        border-collapse: collapse;
        line-height: normal;
        margin-left: auto;
        margin-right: auto;
        color: #333333;
        font-size: 16px;
        font-weight: normal;
        font-style: normal;
        background-color: #FFFFFF;
        width: auto;
        border-top-style: solid;
        border-top-width: 2px;
        border-top-color: #A8A8A8;
        border-right-style: none;
        border-right-width: 2px;
        border-right-color: #D3D3D3;
        border-bottom-style: solid;
        border-bottom-width: 2px;
        border-bottom-color: #A8A8A8;
        border-left-style: none;
        border-left-width: 2px;
        border-left-color: #D3D3D3;
      }
      
      #study_table_hide_gt .gt_caption {
        padding-top: 4px;
        padding-bottom: 4px;
      }
      
      #study_table_hide_gt .gt_title {
        color: #333333;
        font-size: 125%;
        font-weight: initial;
        padding-top: 2px;
        padding-bottom: 2px;
        padding-left: 5px;
        padding-right: 5px;
        border-bottom-color: #FFFFFF;
        border-bottom-width: 0;
      }
      
      #study_table_hide_gt .gt_subtitle {
        color: #333333;
        font-size: 85%;
        font-weight: initial;
        padding-top: 1px;
        padding-bottom: 3px;
        padding-left: 5px;
        padding-right: 5px;
        border-top-color: #FFFFFF;
        border-top-width: 0;
      }
      
      #study_table_hide_gt .gt_heading {
        background-color: #FFFFFF;
        text-align: center;
        border-bottom-color: #FFFFFF;
        border-left-style: none;
        border-left-width: 1px;
        border-left-color: #D3D3D3;
        border-right-style: none;
        border-right-width: 1px;
        border-right-color: #D3D3D3;
      }
      
      #study_table_hide_gt .gt_bottom_border {
        border-bottom-style: solid;
        border-bottom-width: 2px;
        border-bottom-color: #D3D3D3;
      }
      
      #study_table_hide_gt .gt_col_headings {
        border-top-style: solid;
        border-top-width: 2px;
        border-top-color: #D3D3D3;
        border-bottom-style: solid;
        border-bottom-width: 2px;
        border-bottom-color: #D3D3D3;
        border-left-style: none;
        border-left-width: 1px;
        border-left-color: #D3D3D3;
        border-right-style: none;
        border-right-width: 1px;
        border-right-color: #D3D3D3;
      }
      
      #study_table_hide_gt .gt_col_heading {
        color: #333333;
        background-color: #FFFFFF;
        font-size: 100%;
        font-weight: normal;
        text-transform: inherit;
        border-left-style: none;
        border-left-width: 1px;
        border-left-color: #D3D3D3;
        border-right-style: none;
        border-right-width: 1px;
        border-right-color: #D3D3D3;
        vertical-align: bottom;
        padding-top: 2.5px;
        padding-bottom: 3.5px;
        padding-left: 5px;
        padding-right: 5px;
        overflow-x: hidden;
      }
      
      #study_table_hide_gt .gt_column_spanner_outer {
        color: #333333;
        background-color: #FFFFFF;
        font-size: 100%;
        font-weight: normal;
        text-transform: inherit;
        padding-top: 0;
        padding-bottom: 0;
        padding-left: 4px;
        padding-right: 4px;
      }
      
      #study_table_hide_gt .gt_column_spanner_outer:first-child {
        padding-left: 0;
      }
      
      #study_table_hide_gt .gt_column_spanner_outer:last-child {
        padding-right: 0;
      }
      
      #study_table_hide_gt .gt_column_spanner {
        border-bottom-style: solid;
        border-bottom-width: 2px;
        border-bottom-color: #D3D3D3;
        vertical-align: bottom;
        padding-top: 2.5px;
        padding-bottom: 2.5px;
        overflow-x: hidden;
        display: inline-block;
        width: 100%;
      }
      
      #study_table_hide_gt .gt_spanner_row {
        border-bottom-style: hidden;
      }
      
      #study_table_hide_gt .gt_group_heading {
        padding-top: 4px;
        padding-bottom: 4px;
        padding-left: 5px;
        padding-right: 5px;
        color: #333333;
        background-color: #FFFFFF;
        font-size: 100%;
        font-weight: initial;
        text-transform: inherit;
        border-top-style: solid;
        border-top-width: 2px;
        border-top-color: #D3D3D3;
        border-bottom-style: solid;
        border-bottom-width: 2px;
        border-bottom-color: #D3D3D3;
        border-left-style: none;
        border-left-width: 1px;
        border-left-color: #D3D3D3;
        border-right-style: none;
        border-right-width: 1px;
        border-right-color: #D3D3D3;
        vertical-align: middle;
        text-align: left;
      }
      
      #study_table_hide_gt .gt_empty_group_heading {
        padding: 0.5px;
        color: #333333;
        background-color: #FFFFFF;
        font-size: 100%;
        font-weight: initial;
        border-top-style: solid;
        border-top-width: 2px;
        border-top-color: #D3D3D3;
        border-bottom-style: solid;
        border-bottom-width: 2px;
        border-bottom-color: #D3D3D3;
        vertical-align: middle;
      }
      
      #study_table_hide_gt .gt_from_md > :first-child {
        margin-top: 0;
      }
      
      #study_table_hide_gt .gt_from_md > :last-child {
        margin-bottom: 0;
      }
      
      #study_table_hide_gt .gt_row {
        padding-top: 4px;
        padding-bottom: 4px;
        padding-left: 5px;
        padding-right: 5px;
        margin: 10px;
        border-top-style: solid;
        border-top-width: 1px;
        border-top-color: #D3D3D3;
        border-left-style: none;
        border-left-width: 1px;
        border-left-color: #D3D3D3;
        border-right-style: none;
        border-right-width: 1px;
        border-right-color: #D3D3D3;
        vertical-align: middle;
        overflow-x: hidden;
      }
      
      #study_table_hide_gt .gt_stub {
        color: #333333;
        background-color: #FFFFFF;
        font-size: 100%;
        font-weight: initial;
        text-transform: inherit;
        border-right-style: solid;
        border-right-width: 2px;
        border-right-color: #D3D3D3;
        padding-left: 5px;
        padding-right: 5px;
      }
      
      #study_table_hide_gt .gt_stub_row_group {
        color: #333333;
        background-color: #FFFFFF;
        font-size: 100%;
        font-weight: initial;
        text-transform: inherit;
        border-right-style: solid;
        border-right-width: 2px;
        border-right-color: #D3D3D3;
        padding-left: 5px;
        padding-right: 5px;
        vertical-align: top;
      }
      
      #study_table_hide_gt .gt_row_group_first td {
        border-top-width: 2px;
      }
      
      #study_table_hide_gt .gt_row_group_first th {
        border-top-width: 2px;
      }
      
      #study_table_hide_gt .gt_summary_row {
        color: #333333;
        background-color: #FFFFFF;
        text-transform: inherit;
        padding-top: 4px;
        padding-bottom: 4px;
        padding-left: 5px;
        padding-right: 5px;
      }
      
      #study_table_hide_gt .gt_first_summary_row {
        border-top-style: solid;
        border-top-color: #D3D3D3;
      }
      
      #study_table_hide_gt .gt_first_summary_row.thick {
        border-top-width: 2px;
      }
      
      #study_table_hide_gt .gt_last_summary_row {
        padding-top: 4px;
        padding-bottom: 4px;
        padding-left: 5px;
        padding-right: 5px;
        border-bottom-style: solid;
        border-bottom-width: 2px;
        border-bottom-color: #D3D3D3;
      }
      
      #study_table_hide_gt .gt_grand_summary_row {
        color: #333333;
        background-color: #FFFFFF;
        text-transform: inherit;
        padding-top: 4px;
        padding-bottom: 4px;
        padding-left: 5px;
        padding-right: 5px;
      }
      
      #study_table_hide_gt .gt_first_grand_summary_row {
        padding-top: 4px;
        padding-bottom: 4px;
        padding-left: 5px;
        padding-right: 5px;
        border-top-style: double;
        border-top-width: 6px;
        border-top-color: #D3D3D3;
      }
      
      #study_table_hide_gt .gt_last_grand_summary_row_top {
        padding-top: 4px;
        padding-bottom: 4px;
        padding-left: 5px;
        padding-right: 5px;
        border-bottom-style: double;
        border-bottom-width: 6px;
        border-bottom-color: #D3D3D3;
      }
      
      #study_table_hide_gt .gt_striped {
        background-color: rgba(128, 128, 128, 0.05);
      }
      
      #study_table_hide_gt .gt_table_body {
        border-top-style: solid;
        border-top-width: 2px;
        border-top-color: #D3D3D3;
        border-bottom-style: solid;
        border-bottom-width: 2px;
        border-bottom-color: #D3D3D3;
      }
      
      #study_table_hide_gt .gt_footnotes {
        color: #333333;
        background-color: #FFFFFF;
        border-bottom-style: none;
        border-bottom-width: 2px;
        border-bottom-color: #D3D3D3;
        border-left-style: none;
        border-left-width: 2px;
        border-left-color: #D3D3D3;
        border-right-style: none;
        border-right-width: 2px;
        border-right-color: #D3D3D3;
      }
      
      #study_table_hide_gt .gt_footnote {
        margin: 0px;
        font-size: 90%;
        padding-top: 2px;
        padding-bottom: 2px;
        padding-left: 5px;
        padding-right: 5px;
      }
      
      #study_table_hide_gt .gt_sourcenotes {
        color: #333333;
        background-color: #FFFFFF;
        border-bottom-style: none;
        border-bottom-width: 2px;
        border-bottom-color: #D3D3D3;
        border-left-style: none;
        border-left-width: 2px;
        border-left-color: #D3D3D3;
        border-right-style: none;
        border-right-width: 2px;
        border-right-color: #D3D3D3;
      }
      
      #study_table_hide_gt .gt_sourcenote {
        font-size: 90%;
        padding-top: 2px;
        padding-bottom: 2px;
        padding-left: 5px;
        padding-right: 5px;
      }
      
      #study_table_hide_gt .gt_left {
        text-align: left;
      }
      
      #study_table_hide_gt .gt_center {
        text-align: center;
      }
      
      #study_table_hide_gt .gt_right {
        text-align: right;
        font-variant-numeric: tabular-nums;
      }
      
      #study_table_hide_gt .gt_font_normal {
        font-weight: normal;
      }
      
      #study_table_hide_gt .gt_font_bold {
        font-weight: bold;
      }
      
      #study_table_hide_gt .gt_font_italic {
        font-style: italic;
      }
      
      #study_table_hide_gt .gt_super {
        font-size: 65%;
      }
      
      #study_table_hide_gt .gt_footnote_marks {
        font-size: 75%;
        vertical-align: 0.4em;
        position: initial;
      }
      
      #study_table_hide_gt .gt_asterisk {
        font-size: 100%;
        vertical-align: 0;
      }
      
      #study_table_hide_gt .gt_indent_1 {
        text-indent: 5px;
      }
      
      #study_table_hide_gt .gt_indent_2 {
        text-indent: 10px;
      }
      
      #study_table_hide_gt .gt_indent_3 {
        text-indent: 15px;
      }
      
      #study_table_hide_gt .gt_indent_4 {
        text-indent: 20px;
      }
      
      #study_table_hide_gt .gt_indent_5 {
        text-indent: 25px;
      }
      
      #study_table_hide_gt .katex-display {
        display: inline-flex !important;
        margin-bottom: 0.75em !important;
      }
      
      #study_table_hide_gt div.Reactable > div.rt-table > div.rt-thead > div.rt-tr.rt-tr-group-header > div.rt-th-group:after {
        height: 0px !important;
      }
      </style>
          <table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
        
        <tbody class="gt_table_body">
          <tr><td headers="Description" class="gt_row gt_left">Study ID</td>
      <td headers="Value" class="gt_row gt_right">Unique Study ID</td></tr>
          <tr><td headers="Description" class="gt_row gt_left">Protocol Title</td>
      <td headers="Value" class="gt_row gt_right">Study Title</td></tr>
          <tr><td headers="Description" class="gt_row gt_left">Nickname</td>
      <td headers="Value" class="gt_row gt_right">Nickname</td></tr>
          <tr><td headers="Description" class="gt_row gt_left">Enrolled Sites</td>
      <td headers="Value" class="gt_row gt_right">10</td></tr>
          <tr><td headers="Description" class="gt_row gt_left">Planned Sites</td>
      <td headers="Value" class="gt_row gt_right">15</td></tr>
          <tr><td headers="Description" class="gt_row gt_left">Enrolled Participants</td>
      <td headers="Value" class="gt_row gt_right">100</td></tr>
          <tr><td headers="Description" class="gt_row gt_left">Planned Participants</td>
      <td headers="Value" class="gt_row gt_right">200</td></tr>
          <tr><td headers="Description" class="gt_row gt_left">Status</td>
      <td headers="Value" class="gt_row gt_right">Ongoing</td></tr>
          <tr><td headers="Description" class="gt_row gt_left">Product</td>
      <td headers="Value" class="gt_row gt_right">Product Name</td></tr>
          <tr><td headers="Description" class="gt_row gt_left">Phase</td>
      <td headers="Value" class="gt_row gt_right">Phase 1</td></tr>
          <tr><td headers="Description" class="gt_row gt_left">Therapeutic Area</td>
      <td headers="Value" class="gt_row gt_right">Therapeutic Area</td></tr>
          <tr><td headers="Description" class="gt_row gt_left">Protocol Indication</td>
      <td headers="Value" class="gt_row gt_right">Indication</td></tr>
          <tr><td headers="Description" class="gt_row gt_left">Protocol Type</td>
      <td headers="Value" class="gt_row gt_right">Type</td></tr>
          <tr><td headers="Description" class="gt_row gt_left">Protocol Row Id</td>
      <td headers="Value" class="gt_row gt_right">123</td></tr>
          <tr><td headers="Description" class="gt_row gt_left">Protocol Product Number</td>
      <td headers="Value" class="gt_row gt_right">456</td></tr>
          <tr><td headers="Description" class="gt_row gt_left">Est Fpfv</td>
      <td headers="Value" class="gt_row gt_right">2023-01-01</td></tr>
          <tr><td headers="Description" class="gt_row gt_left">Est Lpfv</td>
      <td headers="Value" class="gt_row gt_right">2023-12-01</td></tr>
          <tr><td headers="Description" class="gt_row gt_left">Est Lplv</td>
      <td headers="Value" class="gt_row gt_right">2024-01-01</td></tr>
        </tbody>
        
        
      </table>
        </div>
      </div>

# Generated table has correct structure and content w/dfGroups

    Code
      output
    Output
      <h2>Study Status</h2>
      <label class="toggle">
        <input class="toggle-checkbox btn-show-details" type="checkbox"
          data-shown-table="study_table"
          data-hidden-table="study_table_hide"
          data-hidden="false"
          onclick="toggleTables(this)">
        <div class="toggle-switch"></div>
        <span class="toggle-label">Show Details</span>
      </label>
      <div id="study_table" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
        <style>#study_table table {
        font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
        -webkit-font-smoothing: antialiased;
        -moz-osx-font-smoothing: grayscale;
      }
      
      #study_table thead, #study_table tbody, #study_table tfoot, #study_table tr, #study_table td, #study_table th {
        border-style: none;
      }
      
      #study_table p {
        margin: 0;
        padding: 0;
      }
      
      #study_table .gt_table {
        display: table;
        border-collapse: collapse;
        line-height: normal;
        margin-left: auto;
        margin-right: auto;
        color: #333333;
        font-size: 16px;
        font-weight: normal;
        font-style: normal;
        background-color: #FFFFFF;
        width: auto;
        border-top-style: solid;
        border-top-width: 2px;
        border-top-color: #A8A8A8;
        border-right-style: none;
        border-right-width: 2px;
        border-right-color: #D3D3D3;
        border-bottom-style: solid;
        border-bottom-width: 2px;
        border-bottom-color: #A8A8A8;
        border-left-style: none;
        border-left-width: 2px;
        border-left-color: #D3D3D3;
      }
      
      #study_table .gt_caption {
        padding-top: 4px;
        padding-bottom: 4px;
      }
      
      #study_table .gt_title {
        color: #333333;
        font-size: 125%;
        font-weight: initial;
        padding-top: 2px;
        padding-bottom: 2px;
        padding-left: 5px;
        padding-right: 5px;
        border-bottom-color: #FFFFFF;
        border-bottom-width: 0;
      }
      
      #study_table .gt_subtitle {
        color: #333333;
        font-size: 85%;
        font-weight: initial;
        padding-top: 1px;
        padding-bottom: 3px;
        padding-left: 5px;
        padding-right: 5px;
        border-top-color: #FFFFFF;
        border-top-width: 0;
      }
      
      #study_table .gt_heading {
        background-color: #FFFFFF;
        text-align: center;
        border-bottom-color: #FFFFFF;
        border-left-style: none;
        border-left-width: 1px;
        border-left-color: #D3D3D3;
        border-right-style: none;
        border-right-width: 1px;
        border-right-color: #D3D3D3;
      }
      
      #study_table .gt_bottom_border {
        border-bottom-style: solid;
        border-bottom-width: 2px;
        border-bottom-color: #D3D3D3;
      }
      
      #study_table .gt_col_headings {
        border-top-style: solid;
        border-top-width: 2px;
        border-top-color: #D3D3D3;
        border-bottom-style: solid;
        border-bottom-width: 2px;
        border-bottom-color: #D3D3D3;
        border-left-style: none;
        border-left-width: 1px;
        border-left-color: #D3D3D3;
        border-right-style: none;
        border-right-width: 1px;
        border-right-color: #D3D3D3;
      }
      
      #study_table .gt_col_heading {
        color: #333333;
        background-color: #FFFFFF;
        font-size: 100%;
        font-weight: normal;
        text-transform: inherit;
        border-left-style: none;
        border-left-width: 1px;
        border-left-color: #D3D3D3;
        border-right-style: none;
        border-right-width: 1px;
        border-right-color: #D3D3D3;
        vertical-align: bottom;
        padding-top: 2.5px;
        padding-bottom: 3.5px;
        padding-left: 5px;
        padding-right: 5px;
        overflow-x: hidden;
      }
      
      #study_table .gt_column_spanner_outer {
        color: #333333;
        background-color: #FFFFFF;
        font-size: 100%;
        font-weight: normal;
        text-transform: inherit;
        padding-top: 0;
        padding-bottom: 0;
        padding-left: 4px;
        padding-right: 4px;
      }
      
      #study_table .gt_column_spanner_outer:first-child {
        padding-left: 0;
      }
      
      #study_table .gt_column_spanner_outer:last-child {
        padding-right: 0;
      }
      
      #study_table .gt_column_spanner {
        border-bottom-style: solid;
        border-bottom-width: 2px;
        border-bottom-color: #D3D3D3;
        vertical-align: bottom;
        padding-top: 2.5px;
        padding-bottom: 2.5px;
        overflow-x: hidden;
        display: inline-block;
        width: 100%;
      }
      
      #study_table .gt_spanner_row {
        border-bottom-style: hidden;
      }
      
      #study_table .gt_group_heading {
        padding-top: 4px;
        padding-bottom: 4px;
        padding-left: 5px;
        padding-right: 5px;
        color: #333333;
        background-color: #FFFFFF;
        font-size: 100%;
        font-weight: initial;
        text-transform: inherit;
        border-top-style: solid;
        border-top-width: 2px;
        border-top-color: #D3D3D3;
        border-bottom-style: solid;
        border-bottom-width: 2px;
        border-bottom-color: #D3D3D3;
        border-left-style: none;
        border-left-width: 1px;
        border-left-color: #D3D3D3;
        border-right-style: none;
        border-right-width: 1px;
        border-right-color: #D3D3D3;
        vertical-align: middle;
        text-align: left;
      }
      
      #study_table .gt_empty_group_heading {
        padding: 0.5px;
        color: #333333;
        background-color: #FFFFFF;
        font-size: 100%;
        font-weight: initial;
        border-top-style: solid;
        border-top-width: 2px;
        border-top-color: #D3D3D3;
        border-bottom-style: solid;
        border-bottom-width: 2px;
        border-bottom-color: #D3D3D3;
        vertical-align: middle;
      }
      
      #study_table .gt_from_md > :first-child {
        margin-top: 0;
      }
      
      #study_table .gt_from_md > :last-child {
        margin-bottom: 0;
      }
      
      #study_table .gt_row {
        padding-top: 4px;
        padding-bottom: 4px;
        padding-left: 5px;
        padding-right: 5px;
        margin: 10px;
        border-top-style: solid;
        border-top-width: 1px;
        border-top-color: #D3D3D3;
        border-left-style: none;
        border-left-width: 1px;
        border-left-color: #D3D3D3;
        border-right-style: none;
        border-right-width: 1px;
        border-right-color: #D3D3D3;
        vertical-align: middle;
        overflow-x: hidden;
      }
      
      #study_table .gt_stub {
        color: #333333;
        background-color: #FFFFFF;
        font-size: 100%;
        font-weight: initial;
        text-transform: inherit;
        border-right-style: solid;
        border-right-width: 2px;
        border-right-color: #D3D3D3;
        padding-left: 5px;
        padding-right: 5px;
      }
      
      #study_table .gt_stub_row_group {
        color: #333333;
        background-color: #FFFFFF;
        font-size: 100%;
        font-weight: initial;
        text-transform: inherit;
        border-right-style: solid;
        border-right-width: 2px;
        border-right-color: #D3D3D3;
        padding-left: 5px;
        padding-right: 5px;
        vertical-align: top;
      }
      
      #study_table .gt_row_group_first td {
        border-top-width: 2px;
      }
      
      #study_table .gt_row_group_first th {
        border-top-width: 2px;
      }
      
      #study_table .gt_summary_row {
        color: #333333;
        background-color: #FFFFFF;
        text-transform: inherit;
        padding-top: 4px;
        padding-bottom: 4px;
        padding-left: 5px;
        padding-right: 5px;
      }
      
      #study_table .gt_first_summary_row {
        border-top-style: solid;
        border-top-color: #D3D3D3;
      }
      
      #study_table .gt_first_summary_row.thick {
        border-top-width: 2px;
      }
      
      #study_table .gt_last_summary_row {
        padding-top: 4px;
        padding-bottom: 4px;
        padding-left: 5px;
        padding-right: 5px;
        border-bottom-style: solid;
        border-bottom-width: 2px;
        border-bottom-color: #D3D3D3;
      }
      
      #study_table .gt_grand_summary_row {
        color: #333333;
        background-color: #FFFFFF;
        text-transform: inherit;
        padding-top: 4px;
        padding-bottom: 4px;
        padding-left: 5px;
        padding-right: 5px;
      }
      
      #study_table .gt_first_grand_summary_row {
        padding-top: 4px;
        padding-bottom: 4px;
        padding-left: 5px;
        padding-right: 5px;
        border-top-style: double;
        border-top-width: 6px;
        border-top-color: #D3D3D3;
      }
      
      #study_table .gt_last_grand_summary_row_top {
        padding-top: 4px;
        padding-bottom: 4px;
        padding-left: 5px;
        padding-right: 5px;
        border-bottom-style: double;
        border-bottom-width: 6px;
        border-bottom-color: #D3D3D3;
      }
      
      #study_table .gt_striped {
        background-color: rgba(128, 128, 128, 0.05);
      }
      
      #study_table .gt_table_body {
        border-top-style: solid;
        border-top-width: 2px;
        border-top-color: #D3D3D3;
        border-bottom-style: solid;
        border-bottom-width: 2px;
        border-bottom-color: #D3D3D3;
      }
      
      #study_table .gt_footnotes {
        color: #333333;
        background-color: #FFFFFF;
        border-bottom-style: none;
        border-bottom-width: 2px;
        border-bottom-color: #D3D3D3;
        border-left-style: none;
        border-left-width: 2px;
        border-left-color: #D3D3D3;
        border-right-style: none;
        border-right-width: 2px;
        border-right-color: #D3D3D3;
      }
      
      #study_table .gt_footnote {
        margin: 0px;
        font-size: 90%;
        padding-top: 2px;
        padding-bottom: 2px;
        padding-left: 5px;
        padding-right: 5px;
      }
      
      #study_table .gt_sourcenotes {
        color: #333333;
        background-color: #FFFFFF;
        border-bottom-style: none;
        border-bottom-width: 2px;
        border-bottom-color: #D3D3D3;
        border-left-style: none;
        border-left-width: 2px;
        border-left-color: #D3D3D3;
        border-right-style: none;
        border-right-width: 2px;
        border-right-color: #D3D3D3;
      }
      
      #study_table .gt_sourcenote {
        font-size: 90%;
        padding-top: 2px;
        padding-bottom: 2px;
        padding-left: 5px;
        padding-right: 5px;
      }
      
      #study_table .gt_left {
        text-align: left;
      }
      
      #study_table .gt_center {
        text-align: center;
      }
      
      #study_table .gt_right {
        text-align: right;
        font-variant-numeric: tabular-nums;
      }
      
      #study_table .gt_font_normal {
        font-weight: normal;
      }
      
      #study_table .gt_font_bold {
        font-weight: bold;
      }
      
      #study_table .gt_font_italic {
        font-style: italic;
      }
      
      #study_table .gt_super {
        font-size: 65%;
      }
      
      #study_table .gt_footnote_marks {
        font-size: 75%;
        vertical-align: 0.4em;
        position: initial;
      }
      
      #study_table .gt_asterisk {
        font-size: 100%;
        vertical-align: 0;
      }
      
      #study_table .gt_indent_1 {
        text-indent: 5px;
      }
      
      #study_table .gt_indent_2 {
        text-indent: 10px;
      }
      
      #study_table .gt_indent_3 {
        text-indent: 15px;
      }
      
      #study_table .gt_indent_4 {
        text-indent: 20px;
      }
      
      #study_table .gt_indent_5 {
        text-indent: 25px;
      }
      
      #study_table .katex-display {
        display: inline-flex !important;
        margin-bottom: 0.75em !important;
      }
      
      #study_table div.Reactable > div.rt-table > div.rt-thead > div.rt-tr.rt-tr-group-header > div.rt-th-group:after {
        height: 0px !important;
      }
      </style>
        <table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
        
        <tbody class="gt_table_body">
          <tr><td headers="Description" class="gt_row gt_left">Nickname</td>
      <td headers="Value" class="gt_row gt_right">Protocol Nickname</td></tr>
          <tr><td headers="Description" class="gt_row gt_left">Study Status</td>
      <td headers="Value" class="gt_row gt_right">Active</td></tr>
          <tr><td headers="Description" class="gt_row gt_left">Participants Enrolled</td>
      <td headers="Value" class="gt_row gt_right">50</td></tr>
          <tr><td headers="Description" class="gt_row gt_left">Sites Enrolled</td>
      <td headers="Value" class="gt_row gt_right">154</td></tr>
        </tbody>
        
        
      </table>
      </div>
      <div id="study_table_hide" style="display: none;">
        <div id="study_table_hide_gt" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
          <style>#study_table_hide_gt table {
        font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
        -webkit-font-smoothing: antialiased;
        -moz-osx-font-smoothing: grayscale;
      }
      
      #study_table_hide_gt thead, #study_table_hide_gt tbody, #study_table_hide_gt tfoot, #study_table_hide_gt tr, #study_table_hide_gt td, #study_table_hide_gt th {
        border-style: none;
      }
      
      #study_table_hide_gt p {
        margin: 0;
        padding: 0;
      }
      
      #study_table_hide_gt .gt_table {
        display: table;
        border-collapse: collapse;
        line-height: normal;
        margin-left: auto;
        margin-right: auto;
        color: #333333;
        font-size: 16px;
        font-weight: normal;
        font-style: normal;
        background-color: #FFFFFF;
        width: auto;
        border-top-style: solid;
        border-top-width: 2px;
        border-top-color: #A8A8A8;
        border-right-style: none;
        border-right-width: 2px;
        border-right-color: #D3D3D3;
        border-bottom-style: solid;
        border-bottom-width: 2px;
        border-bottom-color: #A8A8A8;
        border-left-style: none;
        border-left-width: 2px;
        border-left-color: #D3D3D3;
      }
      
      #study_table_hide_gt .gt_caption {
        padding-top: 4px;
        padding-bottom: 4px;
      }
      
      #study_table_hide_gt .gt_title {
        color: #333333;
        font-size: 125%;
        font-weight: initial;
        padding-top: 2px;
        padding-bottom: 2px;
        padding-left: 5px;
        padding-right: 5px;
        border-bottom-color: #FFFFFF;
        border-bottom-width: 0;
      }
      
      #study_table_hide_gt .gt_subtitle {
        color: #333333;
        font-size: 85%;
        font-weight: initial;
        padding-top: 1px;
        padding-bottom: 3px;
        padding-left: 5px;
        padding-right: 5px;
        border-top-color: #FFFFFF;
        border-top-width: 0;
      }
      
      #study_table_hide_gt .gt_heading {
        background-color: #FFFFFF;
        text-align: center;
        border-bottom-color: #FFFFFF;
        border-left-style: none;
        border-left-width: 1px;
        border-left-color: #D3D3D3;
        border-right-style: none;
        border-right-width: 1px;
        border-right-color: #D3D3D3;
      }
      
      #study_table_hide_gt .gt_bottom_border {
        border-bottom-style: solid;
        border-bottom-width: 2px;
        border-bottom-color: #D3D3D3;
      }
      
      #study_table_hide_gt .gt_col_headings {
        border-top-style: solid;
        border-top-width: 2px;
        border-top-color: #D3D3D3;
        border-bottom-style: solid;
        border-bottom-width: 2px;
        border-bottom-color: #D3D3D3;
        border-left-style: none;
        border-left-width: 1px;
        border-left-color: #D3D3D3;
        border-right-style: none;
        border-right-width: 1px;
        border-right-color: #D3D3D3;
      }
      
      #study_table_hide_gt .gt_col_heading {
        color: #333333;
        background-color: #FFFFFF;
        font-size: 100%;
        font-weight: normal;
        text-transform: inherit;
        border-left-style: none;
        border-left-width: 1px;
        border-left-color: #D3D3D3;
        border-right-style: none;
        border-right-width: 1px;
        border-right-color: #D3D3D3;
        vertical-align: bottom;
        padding-top: 2.5px;
        padding-bottom: 3.5px;
        padding-left: 5px;
        padding-right: 5px;
        overflow-x: hidden;
      }
      
      #study_table_hide_gt .gt_column_spanner_outer {
        color: #333333;
        background-color: #FFFFFF;
        font-size: 100%;
        font-weight: normal;
        text-transform: inherit;
        padding-top: 0;
        padding-bottom: 0;
        padding-left: 4px;
        padding-right: 4px;
      }
      
      #study_table_hide_gt .gt_column_spanner_outer:first-child {
        padding-left: 0;
      }
      
      #study_table_hide_gt .gt_column_spanner_outer:last-child {
        padding-right: 0;
      }
      
      #study_table_hide_gt .gt_column_spanner {
        border-bottom-style: solid;
        border-bottom-width: 2px;
        border-bottom-color: #D3D3D3;
        vertical-align: bottom;
        padding-top: 2.5px;
        padding-bottom: 2.5px;
        overflow-x: hidden;
        display: inline-block;
        width: 100%;
      }
      
      #study_table_hide_gt .gt_spanner_row {
        border-bottom-style: hidden;
      }
      
      #study_table_hide_gt .gt_group_heading {
        padding-top: 4px;
        padding-bottom: 4px;
        padding-left: 5px;
        padding-right: 5px;
        color: #333333;
        background-color: #FFFFFF;
        font-size: 100%;
        font-weight: initial;
        text-transform: inherit;
        border-top-style: solid;
        border-top-width: 2px;
        border-top-color: #D3D3D3;
        border-bottom-style: solid;
        border-bottom-width: 2px;
        border-bottom-color: #D3D3D3;
        border-left-style: none;
        border-left-width: 1px;
        border-left-color: #D3D3D3;
        border-right-style: none;
        border-right-width: 1px;
        border-right-color: #D3D3D3;
        vertical-align: middle;
        text-align: left;
      }
      
      #study_table_hide_gt .gt_empty_group_heading {
        padding: 0.5px;
        color: #333333;
        background-color: #FFFFFF;
        font-size: 100%;
        font-weight: initial;
        border-top-style: solid;
        border-top-width: 2px;
        border-top-color: #D3D3D3;
        border-bottom-style: solid;
        border-bottom-width: 2px;
        border-bottom-color: #D3D3D3;
        vertical-align: middle;
      }
      
      #study_table_hide_gt .gt_from_md > :first-child {
        margin-top: 0;
      }
      
      #study_table_hide_gt .gt_from_md > :last-child {
        margin-bottom: 0;
      }
      
      #study_table_hide_gt .gt_row {
        padding-top: 4px;
        padding-bottom: 4px;
        padding-left: 5px;
        padding-right: 5px;
        margin: 10px;
        border-top-style: solid;
        border-top-width: 1px;
        border-top-color: #D3D3D3;
        border-left-style: none;
        border-left-width: 1px;
        border-left-color: #D3D3D3;
        border-right-style: none;
        border-right-width: 1px;
        border-right-color: #D3D3D3;
        vertical-align: middle;
        overflow-x: hidden;
      }
      
      #study_table_hide_gt .gt_stub {
        color: #333333;
        background-color: #FFFFFF;
        font-size: 100%;
        font-weight: initial;
        text-transform: inherit;
        border-right-style: solid;
        border-right-width: 2px;
        border-right-color: #D3D3D3;
        padding-left: 5px;
        padding-right: 5px;
      }
      
      #study_table_hide_gt .gt_stub_row_group {
        color: #333333;
        background-color: #FFFFFF;
        font-size: 100%;
        font-weight: initial;
        text-transform: inherit;
        border-right-style: solid;
        border-right-width: 2px;
        border-right-color: #D3D3D3;
        padding-left: 5px;
        padding-right: 5px;
        vertical-align: top;
      }
      
      #study_table_hide_gt .gt_row_group_first td {
        border-top-width: 2px;
      }
      
      #study_table_hide_gt .gt_row_group_first th {
        border-top-width: 2px;
      }
      
      #study_table_hide_gt .gt_summary_row {
        color: #333333;
        background-color: #FFFFFF;
        text-transform: inherit;
        padding-top: 4px;
        padding-bottom: 4px;
        padding-left: 5px;
        padding-right: 5px;
      }
      
      #study_table_hide_gt .gt_first_summary_row {
        border-top-style: solid;
        border-top-color: #D3D3D3;
      }
      
      #study_table_hide_gt .gt_first_summary_row.thick {
        border-top-width: 2px;
      }
      
      #study_table_hide_gt .gt_last_summary_row {
        padding-top: 4px;
        padding-bottom: 4px;
        padding-left: 5px;
        padding-right: 5px;
        border-bottom-style: solid;
        border-bottom-width: 2px;
        border-bottom-color: #D3D3D3;
      }
      
      #study_table_hide_gt .gt_grand_summary_row {
        color: #333333;
        background-color: #FFFFFF;
        text-transform: inherit;
        padding-top: 4px;
        padding-bottom: 4px;
        padding-left: 5px;
        padding-right: 5px;
      }
      
      #study_table_hide_gt .gt_first_grand_summary_row {
        padding-top: 4px;
        padding-bottom: 4px;
        padding-left: 5px;
        padding-right: 5px;
        border-top-style: double;
        border-top-width: 6px;
        border-top-color: #D3D3D3;
      }
      
      #study_table_hide_gt .gt_last_grand_summary_row_top {
        padding-top: 4px;
        padding-bottom: 4px;
        padding-left: 5px;
        padding-right: 5px;
        border-bottom-style: double;
        border-bottom-width: 6px;
        border-bottom-color: #D3D3D3;
      }
      
      #study_table_hide_gt .gt_striped {
        background-color: rgba(128, 128, 128, 0.05);
      }
      
      #study_table_hide_gt .gt_table_body {
        border-top-style: solid;
        border-top-width: 2px;
        border-top-color: #D3D3D3;
        border-bottom-style: solid;
        border-bottom-width: 2px;
        border-bottom-color: #D3D3D3;
      }
      
      #study_table_hide_gt .gt_footnotes {
        color: #333333;
        background-color: #FFFFFF;
        border-bottom-style: none;
        border-bottom-width: 2px;
        border-bottom-color: #D3D3D3;
        border-left-style: none;
        border-left-width: 2px;
        border-left-color: #D3D3D3;
        border-right-style: none;
        border-right-width: 2px;
        border-right-color: #D3D3D3;
      }
      
      #study_table_hide_gt .gt_footnote {
        margin: 0px;
        font-size: 90%;
        padding-top: 2px;
        padding-bottom: 2px;
        padding-left: 5px;
        padding-right: 5px;
      }
      
      #study_table_hide_gt .gt_sourcenotes {
        color: #333333;
        background-color: #FFFFFF;
        border-bottom-style: none;
        border-bottom-width: 2px;
        border-bottom-color: #D3D3D3;
        border-left-style: none;
        border-left-width: 2px;
        border-left-color: #D3D3D3;
        border-right-style: none;
        border-right-width: 2px;
        border-right-color: #D3D3D3;
      }
      
      #study_table_hide_gt .gt_sourcenote {
        font-size: 90%;
        padding-top: 2px;
        padding-bottom: 2px;
        padding-left: 5px;
        padding-right: 5px;
      }
      
      #study_table_hide_gt .gt_left {
        text-align: left;
      }
      
      #study_table_hide_gt .gt_center {
        text-align: center;
      }
      
      #study_table_hide_gt .gt_right {
        text-align: right;
        font-variant-numeric: tabular-nums;
      }
      
      #study_table_hide_gt .gt_font_normal {
        font-weight: normal;
      }
      
      #study_table_hide_gt .gt_font_bold {
        font-weight: bold;
      }
      
      #study_table_hide_gt .gt_font_italic {
        font-style: italic;
      }
      
      #study_table_hide_gt .gt_super {
        font-size: 65%;
      }
      
      #study_table_hide_gt .gt_footnote_marks {
        font-size: 75%;
        vertical-align: 0.4em;
        position: initial;
      }
      
      #study_table_hide_gt .gt_asterisk {
        font-size: 100%;
        vertical-align: 0;
      }
      
      #study_table_hide_gt .gt_indent_1 {
        text-indent: 5px;
      }
      
      #study_table_hide_gt .gt_indent_2 {
        text-indent: 10px;
      }
      
      #study_table_hide_gt .gt_indent_3 {
        text-indent: 15px;
      }
      
      #study_table_hide_gt .gt_indent_4 {
        text-indent: 20px;
      }
      
      #study_table_hide_gt .gt_indent_5 {
        text-indent: 25px;
      }
      
      #study_table_hide_gt .katex-display {
        display: inline-flex !important;
        margin-bottom: 0.75em !important;
      }
      
      #study_table_hide_gt div.Reactable > div.rt-table > div.rt-thead > div.rt-tr.rt-tr-group-header > div.rt-th-group:after {
        height: 0px !important;
      }
      </style>
          <table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
        
        <tbody class="gt_table_body">
          <tr><td headers="Description" class="gt_row gt_left">Protocol Row Id</td>
      <td headers="Value" class="gt_row gt_right">1-1G9113</td></tr>
          <tr><td headers="Description" class="gt_row gt_left">Studyid</td>
      <td headers="Value" class="gt_row gt_right">AA-AA-000-0000</td></tr>
          <tr><td headers="Description" class="gt_row gt_left">Protocol Title</td>
      <td headers="Value" class="gt_row gt_right">Protocol Title</td></tr>
          <tr><td headers="Description" class="gt_row gt_left">Nickname</td>
      <td headers="Value" class="gt_row gt_right">Protocol Nickname</td></tr>
          <tr><td headers="Description" class="gt_row gt_left">Protocol Type</td>
      <td headers="Value" class="gt_row gt_right">Investigator Sponsored</td></tr>
          <tr><td headers="Description" class="gt_row gt_left">Phase</td>
      <td headers="Value" class="gt_row gt_right">P3</td></tr>
          <tr><td headers="Description" class="gt_row gt_left">Num Plan Site</td>
      <td headers="Value" class="gt_row gt_right">190</td></tr>
          <tr><td headers="Description" class="gt_row gt_left">Num Site Actl</td>
      <td headers="Value" class="gt_row gt_right">176</td></tr>
          <tr><td headers="Description" class="gt_row gt_left">Est Fpfv</td>
      <td headers="Value" class="gt_row gt_right">2003-01-01</td></tr>
          <tr><td headers="Description" class="gt_row gt_left">Act Fpfv</td>
      <td headers="Value" class="gt_row gt_right">2003-01-01</td></tr>
          <tr><td headers="Description" class="gt_row gt_left">Est Lplv</td>
      <td headers="Value" class="gt_row gt_right">2021-06-01</td></tr>
          <tr><td headers="Description" class="gt_row gt_left">Act Lplv</td>
      <td headers="Value" class="gt_row gt_right">2021-06-01</td></tr>
          <tr><td headers="Description" class="gt_row gt_left">Est Lpfv</td>
      <td headers="Value" class="gt_row gt_right">2020-06-01</td></tr>
          <tr><td headers="Description" class="gt_row gt_left">Act Lpfv</td>
      <td headers="Value" class="gt_row gt_right">2020-06-01</td></tr>
          <tr><td headers="Description" class="gt_row gt_left">Study Status</td>
      <td headers="Value" class="gt_row gt_right">Active</td></tr>
          <tr><td headers="Description" class="gt_row gt_left">Num Plan Subj</td>
      <td headers="Value" class="gt_row gt_right">1300</td></tr>
          <tr><td headers="Description" class="gt_row gt_left">Num Enrolled Subj M</td>
      <td headers="Value" class="gt_row gt_right">1301</td></tr>
          <tr><td headers="Description" class="gt_row gt_left">Protocol Indication</td>
      <td headers="Value" class="gt_row gt_right">Protocol Indication</td></tr>
          <tr><td headers="Description" class="gt_row gt_left">Product</td>
      <td headers="Value" class="gt_row gt_right">Product</td></tr>
          <tr><td headers="Description" class="gt_row gt_left">Therapeutic Area</td>
      <td headers="Value" class="gt_row gt_right">Therapeutic Area</td></tr>
          <tr><td headers="Description" class="gt_row gt_left">Protocol Product Number</td>
      <td headers="Value" class="gt_row gt_right">123</td></tr>
          <tr><td headers="Description" class="gt_row gt_left">X Rbm Flg</td>
      <td headers="Value" class="gt_row gt_right">Y</td></tr>
          <tr><td headers="Description" class="gt_row gt_left">Participants Enrolled</td>
      <td headers="Value" class="gt_row gt_right">50</td></tr>
          <tr><td headers="Description" class="gt_row gt_left">Sites Enrolled</td>
      <td headers="Value" class="gt_row gt_right">154</td></tr>
        </tbody>
        
        
      </table>
        </div>
      </div>

