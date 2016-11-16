<!--
Skriven av: Philip (HTML + CSS)
-->
<!DOCTYPE html>
<html>
    % include('head.tpl')
    <body>
        %include('nav.tpl')
            <div class="new_accont">
                <div class="container">
                    <h1>Create account</h1>
                    <p>You need an account for posting a quest and see your connections</p>
                    <form name="create_user" id="create_user" method="post" action="/do_create_user">
                        <label for="first_name">Firstname</label>
                        <input placeholder="First name" type="input" name="first_name" id="first_name" value="" required>
                        <label for="last_name">Lastname</label>
                        <input placeholder="Surname" type="input" name="last_name" id="last_name" value="" required>
                        <label for="phone">Phone</label>
                        <input placeholder="Phone number" type="input" name="phone" id="phone" value="" required>
                        <label for="email">Mail</label>
                        <input placeholder="Email address" type="input" name="email" id="email" value="" required>
                        <label for="password">Password</label>
                        <input placeholder="Password" type="password" name="password" id="password" value="" required>
                        <input class="btn submit red" id="create_account" type="submit" value="Create account">
                    </form>
                    <p id="error"></p>
                </div>
            </div>
        %include('footer.tpl')
    </body>
</html>
