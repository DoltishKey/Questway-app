<!DOCTYPE html>
<html>
    % include('head.tpl')
    <body>
        %include('nav_admin.tpl')
        <main class="user_profile">
            <div class="container">
                <div class="heading">
                    <h2>Profile</h2>
                    <a href="/admin_ads/{{user_info[0]}}">Quests</a>
                </div>
                <form action="/update_user/{{user_info[0]}}" method="post">
                    <label for="firstname">First name</label>
                    <input type="text" id="firstname" name="firstname" value="{{user_info[1]}}"/><br>
                    <label for="lastname">Last name</label>
                    <input type="text" id="lastname" name="lastname" value="{{user_info[2]}}"/><br>
                    <label for="email">Mail</label>
                    <input type="text" id="email" name="email" value="{{user_info[3]}}"/><br>
                    <label for="phone">Phone</label>
                    <input type="text" id="phone" name="phone" value="{{user_info[4]}}"/><br>
                    <input type="submit" class="submit btn red" value="Spara">
                </form>
                <a class="remove_profile" href="/admin_reset_password_email/{{user_info[0]}}">Reset password</a> <br>
                <a class="remove_profile" href="/admin_delete_user/{{user_info[0]}}">Remove user</a>
            </div>
        </main>
        %include('footer.tpl')
    </body>
</html>
