
<%# @cd = ChromatographicalDuval.where("id > 1399 AND id < 1527") %>

<%# @cd.each do |array|%>
  <a id="my-btn-<%= array.id %>"class="fcc-btn" href="https://tr.dominio.com/chromatographical_management/chromatographical_duvals/<%= array.id %>/edit" target="_blank">link-<%= array.id %></a>  

  <script type="text/javascript">
  setTimeout(function() {
    document.getElementById('my-btn-<%= array.id %>').click();
}, 1000);
</script>
<% end %>