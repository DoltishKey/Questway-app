<!DOCTYPE html>
<html>
        % include('head.tpl')
    <body>
        % include('nav_employers.tpl')
        <main>
            <h2>Profil</h2>
            <form action="/save_edith_profile" method="post">
                <lable for="firstname">Förnamn</lable>
                <input type="text" id="firstname" name="firstname" value="{{user_info[1]}}"/><br>
                <lable for="lastname">Efternamn</lable>
                <input type="text" id="lastname" name="lastname" value="{{user_info[2]}}"/><br>
                <lable for="email">Mail</lable>
                <input type="text" id="email" name="email" value="{{user_info[3]}}"/><br>
                <lable for="phone">Tele</lable>
                <input type="text" id="phone" name="phone" value="{{user_info[4]}}"/><br>
                <h4>Byta lösenord</h4>
                <lable for="current_password">Nuvarande lösenord</lable>
                <input type="text" id="current_password" name="current_password"/><br>
                <lable for="new_password_one">Nytt lösenord</lable>
                <input type="text" id="new_password_one" name="new_password_one"/><br>
                <lable for="new_password_two">Upprepa nytt lösenord</lable>
                <input type="text" id="new_password_two" name="new_password_two"/><br>
                <input type="submit" value="Spara">
                <br>
                <br>
            </form>
            <hr>
            <a href="/delete_user">Ta bort profil</a>
        </main>
        %include('footer.tpl')
    </body>
</html>
