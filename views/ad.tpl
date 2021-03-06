<!DOCTYPE html>
<html>
    % include('head.tpl')
    <body>
        %if user_lvl == 1:
            %include('nav_admin.tpl')
        %elif user_lvl == 2:
            %include('nav_employers.tpl')
        %else:
            %include('nav.tpl')
        %end
        <main class="spc_ad">
            %if ad_info[10]:
                <div class="intro big" style="background-image:url(../{{ad_info[10]}});">

            %elif ad_info[9]:
                <div class="intro medium">

            %else:
                <div class="intro">
            %end
                %if ad_info[10]:
                <div class="fade"></div>
                %end
                <div class="ad_info">
                    %if ad_info[9]:
                        <div class="logo_ad_container">
                            <div class="logo_img" style="background-image:url(../{{ad_info[9]}});"></div>
                        </div>
                    %end
                    <div class="heading">
                        <h1>{{ad_info[3]}}</h1>
                        <h4>{{ad_info[8]}}</h4>
                    </div>
                </div>
            </div>
            %if ad_info[11] or ad_info[7]:
                <div class="about company">
                    <div class="container">
                        <h3> About {{ad_info[8]}}</h3>
                        <p>{{ad_info[11]}}</p>
                    %if ad_info[7]:
                        <h3> Company website: </h3>
                        <a href="http://{{ad_info[7]}}" target="_blank">{{ad_info[7]}}</a>
                    %end
                    </div>
                </div>
            %end
            <div class="about job">
                <div class="container">
                    <h3>About {{ad_info[3]}}</h3>
                    <p>{{ad_info[4]}}</p>
                </div>
            </div>
            %if user_lvl == 0:
            <div class="about application">
                <div class="container">
                    <h3>Application</h3>
                    <div class="application_message">
                        <h3></h3>
                        <p></p>

                        <a href="/" class="btn submit red">Back to all Quests</a>

                    </div>
                    <form data-ad-id="{{ad_info[0]}}" id="apply_in_job">
                        <h4>Team members</h4>
                        <div>
                            <label for="name">Name</label>
                            <input type="text" name="name" id="name" required><br>
                            <label for="phone">Phone</label>
                            <input type="text" name="phone" id="phone" required><br>
                            <label for="email">Mail</label>
                            <input type="text" name="email" id="email" required><br>
                        </div>
                        <hr>
                        <div id="group_application"></div>
                        <div id="more_members" class="more_members"><div class="icon"></div><p>Add team member +</p></div>
                        <label for="message">Message</label>
                        <textarea name="message" id="message" maxlength="500"></textarea>
                        <p id="form_counter">( 500 )</p>
                        <input class="btn submit red" type="submit" value="Send" id="create_application">
                    </form>
                </div>
            </div>
            %end
            %if user_lvl == 1 or user_lvl == 2:
                <div class="admin_setting">
                    %if user_lvl == 1 and ad_info[6] == 0:
                        %if ad_info[6] == 1:
                            <h2>Published</h2>
                        %else:
                            <p>Waiting for approval</p>
                        %end
                        <p>Created: {{made_date}}</p>
                        <a href="/admin_approve_ad/{{ad_info[1]}}/{{ad_info[0]}}" class="more_members"><div  class="icon approved"></div><p>Approved</p></a>
                        <a href="/admin_denie_ad/{{ad_info[1]}}/{{ad_info[0]}}" class="more_members"><div  class="icon declined"></div><p>Declined</p></a>
                    %end
                    %if user_lvl == 1 or user_lvl == 2:
                        %if ad_info[6] == 1:
                            <h2>Published</h2>
                        %else:
                            <p>Waiting for approval</p>
                        %end
                        <p>Created: {{made_date}}</p>
                        <a href="/job/applications/{{ad_info[0]}}" class="more_members"><div class="icon veiw"></div><p>View Applications</p></a>
                        <a href="/admin_denie_ad/{{ad_info[1]}}/{{ad_info[0]}}" class="more_members"><div class="icon delte"></div><p>Delete ad</p></a>
                    %end
                </div>
            %end
        </main>
        %include('footer.tpl')
    </body>
</html>
