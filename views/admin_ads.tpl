<!DOCTYPE html>
<html>
    % include('head.tpl')
    <body>
        %include('nav_admin.tpl')
        <main class="user_ads">
            <div class="container">
                <div class="heading">
                    <h2>Ads</h2>
                    <a href="/admin_user/{{user_info[0]}}">Profile</a>
                </div>
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

            <div class="shadow"></div>
            <div class="new_ad_form overlay">
                <div class="close close_icon"></div>
                <hr>
                <div class="container">
                    <h2>New ad</h2>
                    <form action="/admin_make_ad/{{user_info[0]}}" method="post" id="new_ad" enctype="multipart/form-data">
                        <div class="new_ad_about_comp">
                            <div class="img_cover" style="background-image:url(../{{user_info[8]}});">
                                %if user_info[8]:
                                    <label for="img_cover" >Change cover photo</label>
                                %else:
                                    <label for="img_cover" >Upload cover photo</label>
                                %end
                                <input type="file" name="img_cover" id="img_cover"><br>
                            </div>
                            <div class="logo_upload" style="background-image:url(../{{user_info[7]}}); background-repeat: no-repeat;">
                                %if user_info[7]:
                                    <label for="img_logo" id="img_logo_label">Change logo</label>
                                %else:
                                    <label for="img_logo" id="img_logo_label">Upload logo</label>
                                %end
                                <input type="file" name="img_logo" id="img_logo"><br>
                            </div>

                            <h6>About the company</h6>
                            <label for="company_name">Company name</label>
                            <input type="text" id="company_name" name="company_name" value="{{user_info[6]}}"/><br>

                            <label for="about_company">About the company</label>
                            <textarea type="text" id="about_company" name="about_company"/>{{user_info[9]}}</textarea><br>

                            <label for="company_link">Link to website</label>
                            <input type="text" id="company_link" name="company_link" value="{{user_info[5]}}"/><br>
                        </div>
                        <div class="new_ad_about_job">
                            <h6>About the job</h6>
                            <label for="ad_title">Ad title</label>
                            <input type="text" id="ad_title" name="ad_title"/><br>

                            <label for="about_job">About the job</label>
                            <textarea type="text" id="about_job" name="about_job"/></textarea><br>
                        </div>

                            <label for="ad_type" class="red_label">Type</label>
                            <div class="select_dropdown">
                                <select id="ad_type" name="ad_type">
                                    %for type in job_types:
                                        <option value="{{type[0]}}">{{type[1]}</option>
                                    %end
                                </select>
                            </div>
                            <div class="tag_continer">
                                <label class=" red_label">Tags</label>
                                <ul class="keys">

                                </ul>
                                <p class="add_one_tag">Ad +</p>
                            </div>
                            <input type="submit" class="submit btn red" id="ad_button" value="Lägg upp">
                    </form>
                </div>
            </div>
        </main>
        %include('footer.tpl')
    </body>
</html>
