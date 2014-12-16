module Given
  ROOT = File.expand_path( '../..', __dir__ )
  TMP  = File.join( ROOT, 'tmp' )

  class << self

    def fixture fixture
      cleanup!

      `rsync -av ./spec/fixtures/#{fixture}/ #{TMP}/`
      Dir.chdir TMP
    end

    def file name, content
      file_path = File.join( TMP, name )
      FileUtils.mkdir_p( File.dirname(file_path) )
      File.open( file_path, 'w' ) do |file|
        file.write content
      end
    end

    def cleanup!
      Dir.chdir ROOT
      `rm -rf #{TMP}`
    end

  end
end
