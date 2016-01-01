def page_status result, count
  df  = result.elements["Results/DisplayFrom"].text.to_i
  dpp = result.elements["Results/DisplayPerPage"].text.to_i
  number_of_results = result.elements["Results/NumberOfResults"].text.to_i
  if number_of_results == 0
    page_info = "該当0件"
  else
    page_info = "#{number_of_results}件中#{df}〜#{df + dpp - 1}件目の検索結果"
  end
  current_page  = (df / count.to_f).ceil
  max_page_size = (number_of_results / count.to_f).ceil
  [page_info, number_of_results, current_page, max_page_size]
end
