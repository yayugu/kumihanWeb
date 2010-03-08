def makePDF(text)
  rndFile = rand(100000000).to_s
  open(rndFile, "w").write(text)
  puts rndFile
  IO.popen("perl pdf.pl #{rnfFile}") do |io|
    puts io.read
  end
end

post '' do
  makePDF params[:mainText]
  params[:mainText]
end
