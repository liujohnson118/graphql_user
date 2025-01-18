ExUnit.start()

# Load support files
Enum.each(File.ls!("test/support"), fn file ->
  Code.require_file("support/#{file}", __DIR__)
end)
