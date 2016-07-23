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
                        <h3>{{ad_info[8]}}</h3>
                        <p>{{ad_info[11]}}</p>
                        <p>{{ad_info[7]}}</p>
                    </div>
                </div>
            %end
            <div class="about job">
                <div class="container">
                    <h3>{{ad_info[3]}}</h3>
                    <p>{{ad_info[4]}}</p>
                </div>
            </div>
            %if user_lvl == 0:
            <div class="about application">
                <div class="container">
                    <h3>Application</h3>
                    <div class="message">
                        <h3></h3>
                        <p></p>
                        <a href="/" class="btn submit red">Back to all ads</a>
                    </div>
                    <form data-ad-id="{{ad_info[0]}}" id="apply_in_job">
                        <h4>Team members</h4>
                        <div>
                            <label for="name">Name</label>
                            <input type="text" name="name" id="name"><br>
                            <label for="phone">Phone</label>
                            <input type="text" name="phone" id="phone"><br>
                            <label for="email">Mail</label>
                            <input type="text" name="email" id="email"><br>
                        </div>
                        <hr>
                        <div id="group_application"></div>
                        <div id="more_members">Add team member +</div>
                        <label for="message">Message</label>
                        <textarea name="message" id="message" maxlength="500"></textarea><br>
                        <p id="form_counter">( 500 )</p>
                        <input class="btn submit red" type="submit" value="Skicka">
                    </form>
                </div>
            </div>
            %end
            %if user_lvl == 1 or user_lvl == 2:
                <div class="admin_setting">
                    %if user_lvl == 1 or user_lvl == 2:
                        <p>{{ad_info[5]}}</p>
                        <a href="/job/applications/{{ad_info[0]}}">Applications</a>
                        <a href="/admin_denie_ad/{{ad_info[1]}}/{{ad_info[0]}}">Delete ad</a>
                        %if ad_info[6] == 1:
                            <p>Publicerad</p>
                        %else:
                            <p>Väntar på att bli godkänd</p>
                        %end
                    %end
                    %if user_lvl == 1 and ad_info[6] == 0:
                        <a href="/admin_approve_ad/{{ad_info[1]}}/{{ad_info[0]}}"><button>Godkänn och publicra annonsen</button></a>
                        <a href="/admin_denie_ad/{{ad_info[1]}}/{{ad_info[0]}}"><button>Godkänn ej, annonsen tas bort</button></a>
                    %end
                </div>
            %end
        </main>
        %include('footer.tpl')
    </body>
</html>
