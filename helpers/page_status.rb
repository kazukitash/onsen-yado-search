def page_status results, count
  df  = results["DisplayFrom"]
  dpp = results["DisplayPerPage"]
  nor = results["NumberOfResults"]
  if nor == 0
    page_info = "該当0件"
  else
    page_info = "#{nor}件中#{df}〜#{df + dpp - 1}件目の検索結果"
  end
  current_page  = (df / count.to_f).ceil
  max_page_size = (nor / count.to_f).ceil
  [page_info, current_page, max_page_size]
end
