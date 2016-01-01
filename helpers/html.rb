def html view
  File.read(File.join('public', "#{view.to_s}.html"))
end
