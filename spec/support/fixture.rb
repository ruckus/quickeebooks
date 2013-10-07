def fixture_path
  File.expand_path("../../xml", __FILE__)
end

def onlineFixture(file)
  File.new(fixture_path + '/online/' + file).read
end

def sharedFixture(file)
  File.new(fixture_path + '/shared/' + file).read
end

def windowsFixture(file)
  File.new(fixture_path + '/windows/' + file).read
end
