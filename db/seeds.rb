User.delete_all
User.reset_pk_sequence
User.create(
    [
        {
            user_name: 'Денис',
            surname: 'Рябченко',
            email: 'test@test.com',
            password: 'qwerty',
            password_confirmation: 'qwerty',
            admin: true,
            confirm_token: nil,
            email_confirmed: true,
            status: true
        },
        {
            user_name: 'Валерия',
            surname: 'Рябченко',
            email: 'test2@test.com',
            password: 'qwerty',
            password_confirmation: 'qwerty',
            confirm_token: nil,
            email_confirmed: true,
            status: true
        },
    ]
)

StatusAlbum.delete_all
StatusAlbum.reset_pk_sequence
StatusAlbum.create(
    [
        {
            status_name: 'Публичный',
        },
        {
            status_name: 'Приватный',
        },
    ]
)
