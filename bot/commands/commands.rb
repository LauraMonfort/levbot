module Commands
  # You can write all your commands as methods here

  # If the command is bound with reply_with specified,
  # you have to deal with user response to the last message and react on it.
  def start_conversation
    # Quick replies are accessible through message object's quick_reply property,
    # by default it's the quick reply text in ALL CAPS
    # you can also react on the text itself
    message.typing_on
    case message.quick_reply
    when 'BRINGER'
      say 'Where are you going?', quick_replies: LOCATIONS
      next_command :bringer_request
    when 'SENDER'
      say 'From where are you sending your item?', quick_replies: LOCATIONS
      next_command :sender_request

    else
      say '🤖'
      # it's always a good idea to have an else, quick replies don't
      # prevent user from typing any message in the dialogue
      stop_thread
    end
    message.typing_off
  end

  def bringer_request
    message.typing_on
    USERS[:query_destination] = message.quick_reply
    case message.quick_reply
    when 'São Paulo, Brazil'
      USERS[:query_origin] = 'Rio de Janeiro, Brazil'
      say 'Nice! When are you planning to travel'
      say '(you can also type it yourself)', quick_replies: DATES
      next_command :bringer_request_date
    when 'Rio de Janeiro, Brazil'
      USERS[:query_origin] = 'São Paulo, Brazil'
      say 'Nice! When are you planning to travel'
      say '(you can also type it yourself)', quick_replies: DATES
      next_command :bringer_request_date
    else
      say 'I did not get it, sorry'
    end
    message.typing_off
  end

  def sender_request
    message.typing_on
    case message.quick_reply
    when 'SP'
      say 'Nice! When do you want to send your item?'
      say '(you can also type it yourself)', quick_replies: DATES
      next_command :sender_request_date_size
    when 'RJ'
      say 'Nice! When do you want to send your item?'
      say '(you can also type it yourself)', quick_replies: DATES
      next_command :sender_request_date_size
    else
      say 'I did not get it, sorry'
    end
    message.typing_off
  end


  def bringer_request_date
    message.typing_on
    case message.quick_reply
    when 'TOMORROW'
      date = Date.today + 1
      say 'Thanks for your request. Wait a second...'
    when 'TODAY'
      date = Date.today
      say 'Thanks for your request. Wait a second...'
    else
      date = Date.parse(message.text)
      say 'Thanks for your request. Wait a second...'
    end
    USERS[:query_delivery_date] = date.to_s
    message.typing_off

    search_url = "#{INDEX_BASE_URL}?#{URI.encode_www_form(USERS)}"
    # search_url = 'https://www.lewagon.com/'
    open_graph_element = UI::FBOpenGraphTemplate.new(search_url, [{title: 'Button', url: search_url, type: 'web_url' }])
    show(open_graph_element)

    stop_thread  # future messages from user will be handled from top-level bindings
  end

  def sender_request_date_size
    message.typing_on
    case message.quick_reply
    when 'TOMORROW'
      say Date.today + 1
      say 'Wonderful! What is the size of you item?', quick_replies: SIZES
      next_command :sender_request_comment
    when 'TODAY'
      say Date.today
      say 'Wonderful! What is the size of you item?', quick_replies: SIZES
      next_command :sender_request_comment
    else
      say Date.parse(message.text)
      say 'Wonderful! What is the size of you item?', quick_replies: SIZES
      next_command :sender_request_comment
    end
    message.typing_off
  end

  def sender_request_comment
    message.typing_on
    case message.quick_reply
    when 'POCKET'
      say 'Amazing! Please add some comment'
      next_command :sender_request_comment_confirmation
    when 'BAG'
      say 'Amazing! Please add some comment'
      next_command :sender_request_comment_confirmation
    when 'CAR'
      say 'Amazing! Please add some comment'
      next_command :sender_request_comment_confirmation
    when 'BIG CAR'
      say 'Amazing! Please add some comment'
      next_command :sender_request_comment_confirmation
    else
      say 'Amazing! Please add some comment'
      next_command :sender_request_comment_confirmation
    end
    message.typing_off
  end

  def sender_request_comment_confirmation
    message.typing_on
    say 'This is the comment you added about the object:'
    say message.text, quick_replies: SIMPLE_CONFIRMATIONS
    next_command :sender_request_photo
    message.typing_off
  end

  def sender_request_photo
    message.typing_on
    case message.quick_reply
    when 'Y'
    say 'Please upload a picture of you item'
    next_command :sender_request_confirmation
    when 'N'
    say 'Please upload a picture of you item'
    next_command :sender_request_confirmation
    else
      say 'I did not get it, sorry'
    end
    message.typing_off
    stop_thread
  end

  def sender_request_confirmation
    say 'This is your delivery request'

    # How to resume input from the user
    say message.text, quick_replies: REQUESTS_CONFIRMATIONS
    next_command :sender_request_confirmation_input
  end

  def sender_request_confirmation_input
    message.typing_on
    case message.quick_reply
    when 'DELETE'
    say 'Are you sure?', quick_replies: SIMPLE_CONFIRMATIONS
    next_command :sender_request_confirmation_delete
    when 'UPDATE'
    say 'Nice! Which part do you need to update?', quick_replies: REQUESTS_UPDATES
    next_command :sender_request_confirmation_update
    when 'PUBLISH'
    say 'Thanks you for your request. It has been published!'
    stop_thread
    else
      say 'I did not get it, sorry'
    end
    message.typing_off
  end

  def sender_request_confirmation_delete
    message.typing_on
    case message.quick_reply
    when 'Y'
    say 'Your request have been delete'
    next_command :sender_request_confirmation
    stop_thread
    when 'N'
    say 'What do you want to do?'
    next_command :sender_request_confirmation
    else
      say 'I did not get it, sorry'
    end
    message.typing_off
  end

  def sender_request_confirmation_update
    message.typing_on
    case message.quick_reply
    when 'Y'
    say 'Your request have been delete'
    next_command :start_conversation
    when 'N'
    say 'What do you want to do?'
    next_command :sender_request_confirmation
    else
      say 'I did not get it, sorry'
    end
    message.typing_off
    stop_thread
  end

  # def start_travel
  #   # Quick replies are accessible through message object's quick_reply property,
  #   # by default it's the quick reply text in ALL CAPS
  #   # you can also react on the text itself
  #   message.typing_on
  #   case message.quick_reply
  #   when 'RIO'
  #     say "Nice, you're going to Rio de Janeiro! Be careful about shootings!!!"
  #     say 'Where are you right now?'
  #     next_command :ask_for_size
  #   when 'SP'
  #     say 'São Paulo! What a dreadful place...'
  #     say 'Where are you right now?', quick_replies: LOCATIONS
  #     next_command :ask_for_size
  #   else
  #     say '🤖'
  #     # it's always a good idea to have an else, quick replies don't
  #     # prevent user from typing any message in the dialogue
  #     stop_thread
  #   end
  #   message.typing_off
  # end

  def ask_for_size
    message.typing_on
  end

  def appear_nice
    message.typing_on
    case message.text
    when /job/i then say "We've all been there"
    when /family/i then say "That's just life"
    else
      say 'It shall pass'
    end
    message.typing_off
    stop_thread # future messages from user will be handled from top-level bindings
  end

  def star_wars_search
    say 'Give me a second...'
    message.typing_on
    response = HTTParty.get(ENV['API_BASE_URL'])
    say response.to_s
    message.typing_off
    stop_thread
  end

  def is_text_message?(message)
    !message.text.nil?
  end
end
