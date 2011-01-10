# encoding: utf-8
module Paperclip
  class Thumbnail < Processor
    # Performs the conversion of the +file+ into a thumbnail. Returns the Tempfile
    # that contains the new image.
    def make
      src = @file
      dst = Tempfile.new([@basename, @format ? ".#{@format}" : ''])
      dst.binmode

      begin
        parameters = []
        parameters << source_file_options
        parameters << ":source"
        parameters << transformation_command
        parameters << convert_options
        parameters << ":dest"

        parameters = parameters.flatten.compact.join(" ").strip.squeeze(" ")

        # indexing into it only saves the first frame
        # success = Paperclip.run("convert", parameters, :source => "#{File.expand_path(src.path)}[0]", :dest => File.expand_path(dst.path))

        # modified version for animated thumbnails
        success = Paperclip.run("convert", parameters, :source => "#{File.expand_path(src.path)}", :dest => File.expand_path(dst.path))
      rescue PaperclipCommandLineError => e
        raise PaperclipError, "There was an error processing the thumbnail for #{@basename}" if @whiny
      end

      dst
    end
  end

  class Attachment
    # added optional style args
    def reprocess!(*style_args)
      new_original = Tempfile.new("paperclip-reprocess")
      new_original.binmode
      if old_original = to_file(:original)
        new_original.write( old_original.respond_to?(:get) ? old_original.get : old_original.read )
        new_original.rewind

        @queued_for_write = { :original => new_original }
        post_process(*style_args) # modified

        old_original.close if old_original.respond_to?(:close)

        save
      else
        true
      end
    end

    private

    # added optional style args
    def post_process(*style_args) #:nodoc:
      return if @queued_for_write[:original].nil?
      instance.run_paperclip_callbacks(:post_process) do
        instance.run_paperclip_callbacks(:"#{name}_post_process") do
          post_process_styles(*style_args) #modified
        end
      end
    end

    # added optional style args
    def post_process_styles(*style_args) #:nodoc:
      styles.each do |name, style|
        begin
          # only process the specified styles
          # process all styles if no styles are specified
          if style_args.empty? || style_args.include?(name)
            raise RuntimeError.new("Style #{name} has no processors defined.") if style.processors.blank?
            @queued_for_write[name] = style.processors.inject(@queued_for_write[:original]) do |file, processor|
              Paperclip.processor(processor).make(file, style.processor_options, self)
            end
          end
        rescue PaperclipError => e
          log("An error was received while processing: #{e.inspect}")
          (@errors[:processing] ||= []) << e.message if @whiny
        end
      end
    end
  end
end
