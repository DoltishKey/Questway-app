<!DOCTYPE html>
<html>
        % include('head.tpl')
    <body>
        % include('nav_employers.tpl')
        <main id="wrapping_edit">
            <h2>Profile</h2>
            <form action="/save_edith_profile" method="post">
                <label for="firstname">Firstname</label>
                <input type="text" id="firstname" name="firstname" value="{{user_info[1]}}" required/><br>
                <label for="lastname">Surname</label>
                <input type="text" id="lastname" name="lastname" value="{{user_info[2]}}" required/><br>
                <label for="email">Email</label>
                <input type="text" id="email" name="email" value="{{user_info[3]}}" required/><br>
                <label for="phone">Phone</label>
                <input type="text" id="phone" name="phone" value="{{user_info[4]}}"/><br>
                <h4>Change password</h4>
                <label for="current_password">Current password</label>
                <input type="text" id="current_password" name="current_password"/><br>
                <label for="new_password_one">New password</label>
                <input type="text" id="new_password_one" name="new_password_one"/><br>
                <label for="new_password_two">Repeat new password</label>
                <input type="text" id="new_password_two" name="new_password_two"/><br>
                <input type="submit" value="Save" id="save_info">
                <br>
                <br>
            </form>
            <hr>
            <a href="/delete_user">Delete account</a>
        </main>
        %include('footer.tpl')
    </body>
</html>
