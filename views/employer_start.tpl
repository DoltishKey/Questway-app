<!DOCTYPE html>
<html>
        % include('head.tpl')
    <body>
        % include('nav_employers.tpl')
        <main class="user_ads">
            <div class="container">
                <h2>Ads</h2>
                <div>
                    %if len(ads) == 0:
                        <p>There is no ads... yet.</p>
                    %else:
                        %for ad in ads:
                            <a href="/job/applications/{{ad[0]}}" class="ad flexer_parent">
                                <div class="content flexer">
                                    <div class="text">
                                        <h4>{{ad[3]}}</h4>
                                        <div class="status">
                                            %if ad[6] == 1:
                                                <p>Publicerad</p>
                                            %else:
                                                <p>Väntar på att bli godkänd</p>
                                             %end
                                         </div>
                                    </div>
                                    <div class="num_applications">
                                        <div class="user_icon red"></div>
                                        <p>{{ad[12]}} <span>applications<span></p>
                                    </div>
                                    <div class="go"></div>
                                 </div>
                            </a>
                        %end
                    %end
                </div>
                <div class="new_ad overlay_open">
                    <div class="btn red">Create new ad +</div>
                </div>
            </div>
            <div class="shadow">
                <div class="new_ad_form overlay">
                    <div class="close close_icon"></div>
                    <hr>
                    <div class="container">
                        <h2>New ad</h2>
                        <form action="/post_job" method="post" id="new_ad" enctype="multipart/form-data">

                            <div class="img_cover" style="background-image:url(../{{user_info[8]}});">
                                %if user_info[8]:
                                    <label for="img_cover" >Change cover photo</label>
                                %else:
                                    <label for="img_cover" >Upload cover photo</label>
                                %end
                                <input type="file" name="img_cover" id="img_cover"><br>
                            </div>

                            <lable for="company_name">Company Name</lable>
                            <input type="text" id="company_name" name="company_name" value="{{user_info[6]}}"/><br>

                            <lable for="about_company"> Tell the applicant something about the company</lable>
                            <textarea type="text" id="about_company" name="about_company"/>{{user_info[9]}}</textarea><br>

                            <lable for="company_link">Webbsite</lable>
                            <input type="text" id="company_link" name="company_link" value="{{user_info[5]}}"/><br>

                            <h6>THE AD</h6>
                            <lable for="ad_title">Title</lable>
                            <input type="text" id="ad_title" name="ad_title"/><br>

                            <lable for="about_job">Tell the applicant something about the mission</lable>
                            <textarea type="text" id="about_job" name="about_job"/></textarea><br>

                            <label for="ad_type">Category</label>
                            <select id="ad_type" name="ad_type">
                                %for type in job_types:
                                <option value="{{type[0]}}">{{type[1]}}</option>
                                %end
                            </select><br>
                            <div class="tag_continer">
                                <label class="add_one_tag">Tags</label>
                                <ul class="keys">

                                </ul>
                                <p class="add_one_tag">Add a tag +</p>
                            </div>
                            <input type="submit" id="ad_button" value="Lägg upp">
                        </form>
                    </div>
                </div>
            </div>
        </main>
        %include('footer.tpl')
    </body>
</html>
