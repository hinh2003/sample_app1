import consumer from "./consumer"

document.addEventListener('turbolinks:load', () => {
  const room_element = document.getElementById('room-id');
  const room_id = room_element.getAttribute('data-room-id');

  console.log(consumer.subscriptions)

  consumer.subscriptions.subscriptions.forEach((subscription) => {
    consumer.subscriptions.remove(subscription)
  })

  consumer.subscriptions.create({ channel: "RoomChannel", room_id: room_id }, {
    connected() {
      console.log("connected to " + room_id)
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      const user_element = document.getElementById('user-id');
      const user_id = Number(user_element.getAttribute('data-user-id'));

      if(data.action === 'delete_message' ){
        const messageElement = document.querySelector(`.content-container[data-chatId='${data.message_id}']`);
          if (messageElement) {
          messageElement.parentElement.remove();
        }
       else {
        console.error("Không tìm thấy tin nhắn với ID:", data.message_id);
      }
      }
      if (data.action === 'update_message') {
        const messageContainer = document.querySelector(`.content-container[data-chatId='${data.message.id}']`);
        let html;
        if (user_id === data.message.user_id) {
          html = data.mine;
        } else {
          html = data.theirs;
        }
        const editedText = '<div class="edited"> (edited)</div>';
        if (!html.includes('edited')) {
          html += editedText;
        }
        messageContainer.innerHTML =html
      }

      if(data.action === 'create'){
        let html;
        if (user_id === data.message.user_id) {
        html = data.mine;
      } else {
        html = data.theirs;
      }
        const messageContainer = document.getElementById('messages');
        messageContainer.innerHTML += html;
        messageContainer.scrollTop = messageContainer.scrollHeight;
        document.getElementById('message_content').value = '';
      }
    }
  });
})