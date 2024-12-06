$('.reply-btn').hover(
    function () {
        $(this).find('.reaction-icons').removeClass('hidden');
    },
    function () {
        $(this).find('.reaction-icons').addClass('hidden');
    }
);
$('.reaction-total').hover(
    function () {
        $(this).find('.reaction-user').removeClass('hidden');
    },
    function () {
        $(this).find('.reaction-user').addClass('hidden');
    }
);
const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

$(document).off('click', '.reaction-icon').on('click', '.reaction-icon', function() {
    const reactionType = $(this).data('reaction');
    const micropostId = $(this).data('id');
    const $replyBtn = $(this).closest('.reply-btn');
    const $reactionText = $replyBtn.find('.reaction-text');

    $.ajax({
        url: '/microposts/reactions',
        type: 'POST',
        data: {
            micropost_id: micropostId,
            reaction_type: reactionType
        },
        headers: {
            'X-CSRF-Token': csrfToken
        },
        success: function(response) {
            if (response.success) {
                let reactionIcon = '';
                switch (reactionType) {
                    case 'Like':
                        reactionIcon = '👍';
                        break;
                    case 'Sad':
                        reactionIcon = '😢';
                        break;
                    case 'Angry':
                        reactionIcon = '😡';
                        break;
                    case 'Wow':
                        reactionIcon = '😮';
                        break;
                    default:
                        reactionIcon = 'like';
                        break;
                }

                $reactionText.html(reactionIcon);
            } else {
                alert("Failed to react. Please try again.");
            }
        },
        error: function() {
                location.reload();

        }
    });
});

