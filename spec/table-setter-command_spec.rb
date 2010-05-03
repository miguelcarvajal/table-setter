require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe TableSetter::Command do
  INSTALL_DIRECTORY = File.join "/", "tmp", "table-setter-test", "/"
  TABLE_SETTER = File.join File.dirname(__FILE__), "..", "bin", "table-setter"
  TEMPLATE_DIR = File.join TableSetter::ROOT, "template"

  def cleanup
    if File.exists? INSTALL_DIRECTORY
      FileUtils.rm_r INSTALL_DIRECTORY
    end
  end

  def install
    `#{TABLE_SETTER} install #{INSTALL_DIRECTORY}`
  end
  
  after(:each) do 
    cleanup
  end
  
  before(:each) do
    install
  end
  
  it 'should install the configuration directory in a custom spot' do
    Dir["#{TEMPLATE_DIR}/**/*"].each do |template_file|
      File.exists?(template_file.gsub(TEMPLATE_DIR, INSTALL_DIRECTORY)).should be_true
    end
  end
  
  def build_and_test(prefix="")
    prefix_option = "-p #{prefix}" if prefix.length > 0
    `#{TABLE_SETTER} build #{INSTALL_DIRECTORY} #{prefix_option}`
    Dir["#{TEMPLATE_DIR}/public/*"].each do |asset|
      corrected_path = asset.gsub(File.join(TEMPLATE_DIR, "public"), File.join(INSTALL_DIRECTORY, "out", "#{prefix}"))
      
      File.exists?(corrected_path).should be_true
    end
  end
  
  it 'should build the tables and install the assets in the correct folder with prefix' do
    build_and_test "test"
  end
  
  it 'should build the tables and install the assets in the correct folder without prefix' do
    build_and_test
  end
  
  it 'should build a table' do
    `#{TABLE_SETTER} build #{INSTALL_DIRECTORY}`
    File.exists?("#{INSTALL_DIRECTORY}/out/example/index.html").should be_true
  end

end